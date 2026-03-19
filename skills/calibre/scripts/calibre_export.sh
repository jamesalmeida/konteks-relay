#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'USAGE'
Usage: calibre_export.sh [--library-path PATH] (--id ID | --search QUERY) [options]

Options:
  --format FORMAT   Preferred format (default: epub)
  --to-dir DIR      Destination directory (required)

Examples:
  calibre_export.sh --id 42 --format epub --to-dir /tmp/export
  calibre_export.sh --search "tags:to-read" --format mobi --to-dir /tmp/export
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

ID=""; SEARCH=""; FORMAT="epub"; OUTDIR=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --id) ID="$2"; shift 2;;
    --search) SEARCH="$2"; shift 2;;
    --format) FORMAT="$2"; shift 2;;
    --to-dir) OUTDIR="$2"; shift 2;;
    *) die "Unknown option: $1";;
  esac
done

if [ -z "$ID" ] && [ -z "$SEARCH" ]; then
  usage
  exit 1
fi
[ -n "$OUTDIR" ] || die "--to-dir is required"

CALIBREDB="$(find_calibre_bin "calibredb" || true)"
[ -n "$CALIBREDB" ] || die "calibredb not found. Install with: brew install calibre"

LIB_PATH="$(load_library_path)"
mkdir -p "$OUTDIR"

if [ -n "$ID" ]; then
  $CALIBREDB --with-library "$LIB_PATH" export --to-dir "$OUTDIR" --formats "$FORMAT" "$ID"
else
  command -v python3 >/dev/null 2>&1 || die "python3 is required for export search parsing"
  # NOTE: --for-machine JSON output is required for reliable ID parsing; verify flag support if errors occur.
  ids="$($CALIBREDB --with-library "$LIB_PATH" list --for-machine --fields id --search "$SEARCH" --limit 0 | \
    python3 - <<'PY'
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

ids = [str(book.get("id")) for book in data if book.get("id") is not None]
print(",".join(ids))
PY
  )"
  [ -n "$ids" ] || die "No matching books for search: $SEARCH"
  $CALIBREDB --with-library "$LIB_PATH" export --to-dir "$OUTDIR" --formats "$FORMAT" "$ids"
fi
