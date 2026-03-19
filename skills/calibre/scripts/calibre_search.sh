#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'USAGE'
Usage: calibre_search.sh [--library-path PATH] <command> [options]

Commands:
  search --field FIELD --query QUERY [--columns COLS] [--limit N]
  list [--search QUERY] [--columns COLS] [--limit N]
  recent [--days N] [--columns COLS] [--limit N]
  details --id ID
  duplicates [--threshold N]

Fields: title, authors, tags, series, publisher, rating

Examples:
  calibre_search.sh --library-path /path/lib search --field title --query "Dune"
  calibre_search.sh list --search "tags:to-read" --columns "title,authors,formats"
  calibre_search.sh recent --days 30
  calibre_search.sh details --id 42
  calibre_search.sh duplicates
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

list_common() {
  local search_query="$1"
  local columns="$2"
  local limit="$3"
  local args=("--with-library" "$LIB_PATH" "list")
  if [ -n "$columns" ]; then
    args+=("--fields" "$columns")
  fi
  if [ -n "$search_query" ]; then
    args+=("--search" "$search_query")
  fi
  if [ -n "$limit" ]; then
    args+=("--limit" "$limit")
  fi
  "$CALIBREDB" "${args[@]}"
}

case "$CMD" in
  search)
    field=""; query=""; columns=""; limit=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --field) field="$2"; shift 2;;
        --query) query="$2"; shift 2;;
        --columns) columns="$2"; shift 2;;
        --limit) limit="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$field" ] || die "search requires --field"
    [ -n "$query" ] || die "search requires --query"
    list_common "${field}:${query}" "$columns" "$limit"
    ;;
  list)
    search_query=""; columns=""; limit=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --search) search_query="$2"; shift 2;;
        --columns) columns="$2"; shift 2;;
        --limit) limit="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    list_common "$search_query" "$columns" "$limit"
    ;;
  recent)
    days="30"; columns=""; limit=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --days) days="$2"; shift 2;;
        --columns) columns="$2"; shift 2;;
        --limit) limit="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    list_common "date:>${days}daysago" "$columns" "$limit"
    ;;
  details)
    id=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --id) id="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    [ -n "$id" ] || die "details requires --id"
    "$CALIBREDB" --with-library "$LIB_PATH" show_metadata "$id"
    echo ""
    "$CALIBREDB" --with-library "$LIB_PATH" list --search "id:$id" --fields "formats,path"
    ;;
  duplicates)
    threshold="1"
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --threshold) threshold="$2"; shift 2;;
        *) die "Unknown option: $1";;
      esac
    done
    if command -v python3 >/dev/null 2>&1; then
      "$CALIBREDB" --with-library "$LIB_PATH" list --fields "title,authors" --separator $'\t' --limit 0 | \
        python3 - <<'PY'
import sys, re
from collections import defaultdict

rows = []
for line in sys.stdin:
    line = line.rstrip("\n")
    if not line:
        continue
    parts = line.split("\t")
    if len(parts) < 3:
        continue
    book_id, title, authors = parts[0], parts[1], parts[2]
    key = re.sub(r"[^a-z0-9]+", " ", f"{title} {authors}".lower()).strip()
    rows.append((key, book_id, title, authors))

bucket = defaultdict(list)
for key, book_id, title, authors in rows:
    bucket[key].append((book_id, title, authors))

for key, items in bucket.items():
    if len(items) > 1:
        print("Duplicate candidate:")
        for book_id, title, authors in items:
            print(f"  id={book_id} title={title} authors={authors}")
PY
    else
      die "python3 is required for duplicate detection"
    fi
    ;;
  *)
    usage
    exit 1
    ;;
esac
