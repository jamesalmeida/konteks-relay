#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'USAGE'
Usage: calibre_import.sh [--library-path PATH] (--file FILE | --dir DIR) [options]

Options:
  --with-metadata     Fetch metadata after import
  --duplicates        Allow adding duplicates

Examples:
  calibre_import.sh --library-path /path/lib --file /books/book.epub --with-metadata
  calibre_import.sh --dir /books --duplicates
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

FILE=""; DIR=""; WITH_META="false"; DUPES="false"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --file) FILE="$2"; shift 2;;
    --dir) DIR="$2"; shift 2;;
    --with-metadata) WITH_META="true"; shift;;
    --duplicates) DUPES="true"; shift;;
    *) die "Unknown option: $1";;
  esac
done

if [ -z "$FILE" ] && [ -z "$DIR" ]; then
  usage
  exit 1
fi

CALIBREDB="$(find_calibre_bin "calibredb" || true)"
[ -n "$CALIBREDB" ] || die "calibredb not found. Install with: brew install calibre"

LIB_PATH="$(load_library_path)"

add_args=("--with-library" "$LIB_PATH" "add")
if [ "$DUPES" = "true" ]; then
  add_args+=("--duplicates")
fi

if [ -n "$FILE" ]; then
  [ -f "$FILE" ] || die "File not found: $FILE"
  output="$($CALIBREDB "${add_args[@]}" "$FILE")"
else
  [ -d "$DIR" ] || die "Directory not found: $DIR"
  output="$($CALIBREDB "${add_args[@]}" -r "$DIR")"
fi

echo "$output"

if [ "$WITH_META" = "true" ]; then
  FETCH_META="$(find_calibre_bin "fetch-ebook-metadata" || true)"
  [ -n "$FETCH_META" ] || die "fetch-ebook-metadata not found"

  ids="$(echo "$output" | awk -F': ' '/Added book ids?:/ {print $2}' | tr ',' ' ' | xargs)"
  [ -n "$ids" ] || die "Could not parse added book id(s)"

  for id in $ids; do
    tmp_opf="$(mktemp)"
    meta_out="$($CALIBREDB --with-library "$LIB_PATH" show_metadata "$id")"
    title="$(echo "$meta_out" | awk -F': ' '/^Title/ {print $2; exit}')"
    authors="$(echo "$meta_out" | awk -F': ' '/^Author\(s\)/ {print $2; exit}')"
    if [ -z "$title" ] || [ -z "$authors" ]; then
      echo "Skipping metadata fetch for id=$id (missing title/authors)" >&2
      rm -f "$tmp_opf"
      continue
    fi
    "$FETCH_META" --title "$title" --authors "$authors" --opf "$tmp_opf" >/dev/null 2>&1 || true
    if [ -s "$tmp_opf" ]; then
      $CALIBREDB --with-library "$LIB_PATH" set_metadata "$id" --from-opf "$tmp_opf" >/dev/null
      echo "Updated metadata for id=$id"
    else
      echo "No metadata found for id=$id" >&2
    fi
    rm -f "$tmp_opf"
  done
fi
