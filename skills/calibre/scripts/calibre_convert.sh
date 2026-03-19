#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'USAGE'
Usage: calibre_convert.sh [--library-path PATH] (--input FILE | --id ID | --dir DIR) [options]

Options:
  --format FORMAT     Output format (default: epub)
  --output-dir DIR    Output directory (default: current directory)

Examples:
  calibre_convert.sh --input /books/book.epub --format mobi --output-dir /tmp/out
  calibre_convert.sh --id 42 --format pdf --output-dir /tmp/out
  calibre_convert.sh --dir /books --format epub --output-dir /tmp/out
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

INPUT=""; ID=""; DIR=""; FORMAT="epub"; OUTDIR="."
while [ "$#" -gt 0 ]; do
  case "$1" in
    --input) INPUT="$2"; shift 2;;
    --id) ID="$2"; shift 2;;
    --dir) DIR="$2"; shift 2;;
    --format) FORMAT="$2"; shift 2;;
    --output-dir) OUTDIR="$2"; shift 2;;
    *) die "Unknown option: $1";;
  esac
done

if [ -z "$INPUT" ] && [ -z "$ID" ] && [ -z "$DIR" ]; then
  usage
  exit 1
fi

EBOOK_CONVERT="$(find_calibre_bin "ebook-convert" || true)"
[ -n "$EBOOK_CONVERT" ] || die "ebook-convert not found. Install with: brew install calibre"

mkdir -p "$OUTDIR"

convert_file() {
  local in_file="$1"
  local base
  base="$(basename "$in_file")"
  local name="${base%.*}"
  local out_file="$OUTDIR/${name}.${FORMAT}"
  "$EBOOK_CONVERT" "$in_file" "$out_file"
  echo "Converted: $out_file"
}

if [ -n "$INPUT" ]; then
  [ -f "$INPUT" ] || die "File not found: $INPUT"
  convert_file "$INPUT"
  exit 0
fi

if [ -n "$DIR" ]; then
  [ -d "$DIR" ] || die "Directory not found: $DIR"
  shopt -s nullglob
  for f in "$DIR"/*; do
    if [ -f "$f" ]; then
      convert_file "$f"
    fi
  done
  exit 0
fi

if [ -n "$ID" ]; then
  CALIBREDB="$(find_calibre_bin "calibredb" || true)"
  [ -n "$CALIBREDB" ] || die "calibredb not found. Install with: brew install calibre"
  LIB_PATH="$(load_library_path)"
  tmp_dir="$(mktemp -d)"
  # NOTE: --single-dir/--formats all flags can vary by Calibre version; verify if export fails.
  "$CALIBREDB" --with-library "$LIB_PATH" export --to-dir "$tmp_dir" --single-dir --formats all "$ID" >/dev/null
  found_file=""
  for f in "$tmp_dir"/*; do
    if [ -f "$f" ]; then
      found_file="$f"
      break
    fi
  done
  if [ -z "$found_file" ]; then
    rm -rf "$tmp_dir"
    die "No exported file found for id=$ID"
  fi
  convert_file "$found_file"
  rm -rf "$tmp_dir"
fi
