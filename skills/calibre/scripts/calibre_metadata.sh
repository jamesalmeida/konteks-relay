#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'USAGE'
Usage: calibre_metadata.sh [--library-path PATH] <command> [options]

Commands:
  fetch --id ID
  update --id ID [--title T] [--authors A] [--tags T] [--series S] [--series-index N] [--rating R] [--comments C]
  tags-add --ids "1,2" --tags "tag1,tag2"
  tags-remove --ids "1,2" --tags "tag1,tag2"
  cover --id ID --file PATH
  cover --id ID --download
  audit [--missing-covers] [--missing-metadata] [--missing-formats] [--check-library]

Examples:
  calibre_metadata.sh update --id 42 --title "New" --tags "sci-fi,classic"
  calibre_metadata.sh tags-add --ids "1,2" --tags "to-read"
  calibre_metadata.sh cover --id 42 --download
  calibre_metadata.sh audit --missing-covers --missing-metadata
USAGE
}

die() { echo "Error: $*" >&2; exit 1; }

CALIBRE_LIB_PATH=""
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "${1:-}" = "--library-path" ]; then
  [ -n "${2:-}" ] || die "--library-path requires a value"
  CALIBRE_LIB_PATH="$2"
  save_library_path "$CALIBRE_LIB_PATH"
  shift 2
fi

CMD="${1:-}"
[ -n "$CMD" ] || { usage; exit 1; }
shift || true

CALIBREDB="$(find_calibre_bin "calibredb" || true)"
[ -n "$CALIBREDB" ] || die "calibredb not found. Install with: brew install calibre"

LIB_PATH="$(load_library_path)"

case "$CMD" in
  fetch)
    id=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --id) id="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$id" ] || die "fetch requires --id"
    FETCH_META="$(find_calibre_bin "fetch-ebook-metadata" || true)"
    [ -n "$FETCH_META" ] || die "fetch-ebook-metadata not found"

    meta_out="$($CALIBREDB --with-library "$LIB_PATH" show_metadata "$id")"
    title="$(echo "$meta_out" | awk -F': ' '/^Title/ {print $2; exit}')"
    authors="$(echo "$meta_out" | awk -F': ' '/^Author\(s\)/ {print $2; exit}')"
    [ -n "$title" ] || die "Missing title for id=$id"
    [ -n "$authors" ] || die "Missing authors for id=$id"

    tmp_opf="$(mktemp)"
    "$FETCH_META" --title "$title" --authors "$authors" --opf "$tmp_opf" >/dev/null 2>&1 || true
    if [ -s "$tmp_opf" ]; then
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --from-opf "$tmp_opf" >/dev/null
      echo "Updated metadata for id=$id"
    else
      echo "No metadata found for id=$id" >&2
    fi
    rm -f "$tmp_opf"
    ;;
  update)
    id=""; title=""; authors=""; tags=""; series=""; series_index=""; rating=""; comments=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --id) id="$2"; shift 2;;
        --title) title="$2"; shift 2;;
        --authors) authors="$2"; shift 2;;
        --tags) tags="$2"; shift 2;;
        --series) series="$2"; shift 2;;
        --series-index) series_index="$2"; shift 2;;
        --rating) rating="$2"; shift 2;;
        --comments) comments="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$id" ] || die "update requires --id"
    fields=()
    [ -n "$title" ] && fields+=("title:$title")
    [ -n "$authors" ] && fields+=("authors:$authors")
    [ -n "$tags" ] && fields+=("tags:$tags")
    [ -n "$series" ] && fields+=("series:$series")
    [ -n "$series_index" ] && fields+=("series_index:$series_index")
    [ -n "$rating" ] && fields+=("rating:$rating")
    [ -n "$comments" ] && fields+=("comments:$comments")
    [ ${#fields[@]} -gt 0 ] || die "No fields provided"
    for f in "${fields[@]}"; do
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --field "$f" >/dev/null
    done
    echo "Updated metadata for id=$id"
    ;;
  tags-add)
    ids=""; tags=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --ids) ids="$2"; shift 2;;
        --tags) tags="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$ids" ] || die "tags-add requires --ids"
    [ -n "$tags" ] || die "tags-add requires --tags"
    IFS=',' read -r -a id_list <<< "$ids"
    for id in "${id_list[@]}"; do
      id="$(echo "$id" | xargs)"
      [ -n "$id" ] || continue
      meta_out="$($CALIBREDB --with-library "$LIB_PATH" show_metadata "$id")"
      current_tags="$(echo "$meta_out" | awk -F': ' '/^Tags/ {print $2; exit}')"
      new_tags="$({
        echo "$current_tags"
        echo "$tags"
      } | tr ',' '\n' | sed 's/^ *//;s/ *$//' | awk 'NF' | sort -u | paste -sd',' -)"
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --field "tags:$new_tags" >/dev/null
      echo "Added tags to id=$id"
    done
    ;;
  tags-remove)
    ids=""; tags=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --ids) ids="$2"; shift 2;;
        --tags) tags="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$ids" ] || die "tags-remove requires --ids"
    [ -n "$tags" ] || die "tags-remove requires --tags"
    IFS=',' read -r -a id_list <<< "$ids"
    for id in "${id_list[@]}"; do
      id="$(echo "$id" | xargs)"
      [ -n "$id" ] || continue
      meta_out="$($CALIBREDB --with-library "$LIB_PATH" show_metadata "$id")"
      current_tags="$(echo "$meta_out" | awk -F': ' '/^Tags/ {print $2; exit}')"
      new_tags="$(echo "$current_tags" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | awk 'NF' | \
        grep -v -F -x -f <(echo "$tags" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | awk 'NF') | paste -sd',' -)"
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --field "tags:$new_tags" >/dev/null
      echo "Removed tags from id=$id"
    done
    ;;
  cover)
    id=""; file=""; download="false"
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --id) id="$2"; shift 2;;
        --file) file="$2"; shift 2;;
        --download) download="true"; shift;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$id" ] || die "cover requires --id"
    if [ -n "$file" ]; then
      [ -f "$file" ] || die "Cover file not found: $file"
      # NOTE: Using set_metadata cover field; verify support if errors occur.
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --field "cover:$file" >/dev/null
      echo "Updated cover for id=$id"
    elif [ "$download" = "true" ]; then
      FETCH_META="$(find_calibre_bin "fetch-ebook-metadata" || true)"
      [ -n "$FETCH_META" ] || die "fetch-ebook-metadata not found"
      meta_out="$($CALIBREDB --with-library "$LIB_PATH" show_metadata "$id")"
      title="$(echo "$meta_out" | awk -F': ' '/^Title/ {print $2; exit}')"
      authors="$(echo "$meta_out" | awk -F': ' '/^Author\(s\)/ {print $2; exit}')"
      [ -n "$title" ] || die "Missing title for id=$id"
      [ -n "$authors" ] || die "Missing authors for id=$id"
      tmp_cover="$(mktemp)"
      "$FETCH_META" --title "$title" --authors "$authors" --cover "$tmp_cover" >/dev/null 2>&1 || true
      if [ -s "$tmp_cover" ]; then
        # NOTE: Using set_metadata cover field; verify support if errors occur.
        $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --field "cover:$tmp_cover" >/dev/null
        echo "Updated cover for id=$id"
      else
        echo "No cover found for id=$id" >&2
      fi
      rm -f "$tmp_cover"
    else
      die "cover requires --file or --download"
    fi
    ;;
  audit)
    missing_covers="false"; missing_metadata="false"; missing_formats="false"; check_library="false"
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --missing-covers) missing_covers="true"; shift;;
        --missing-metadata) missing_metadata="true"; shift;;
        --missing-formats) missing_formats="true"; shift;;
        --check-library) check_library="true"; shift;;
        *) die "Unknown option: $1";;
      esac
    done

    if [ "$check_library" = "true" ]; then
      $CALIBREDB --with-library "$LIB_PATH" check_library
    fi

    if [ "$missing_covers" = "true" ] || [ "$missing_metadata" = "true" ] || [ "$missing_formats" = "true" ]; then
      command -v python3 >/dev/null 2>&1 || die "python3 is required for audit"
      # NOTE: --for-machine JSON output is required for audit parsing; verify flag support if errors occur.
      $CALIBREDB --with-library "$LIB_PATH" list --for-machine --fields "title,authors,tags,formats,has_cover" | \
        python3 - "$missing_covers" "$missing_metadata" "$missing_formats" <<'PY'
import json
import sys

raw = sys.stdin.read().strip()
if not raw:
    sys.exit(0)
try:
    data = json.loads(raw)
except json.JSONDecodeError:
    sys.stderr.write("Failed to parse calibredb JSON output\n")
    sys.exit(1)

missing_covers = len(sys.argv) > 1 and sys.argv[1] == "true"
missing_metadata = len(sys.argv) > 2 and sys.argv[2] == "true"
missing_formats = len(sys.argv) > 3 and sys.argv[3] == "true"

for book in data:
    bid = book.get("id")
    title = book.get("title") or ""
    authors = book.get("authors") or ""
    tags = book.get("tags") or []
    formats = book.get("formats") or []
    has_cover = book.get("has_cover")

    if missing_covers and (has_cover is False or has_cover in (0, "0", "false", "False", None)):
        print(f"Missing cover: id={bid} title={title} authors={authors}")
    if missing_metadata and (not authors or not tags):
        print(f"Missing metadata: id={bid} title={title} authors={authors} tags={tags}")
    if missing_formats and not formats:
        print(f"Missing formats: id={bid} title={title} authors={authors}")
PY
    fi
    ;;
  *)
    usage
    exit 1
    ;;
esac
