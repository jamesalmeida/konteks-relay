#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_FILE="$ROOT_DIR/TOOLS.md"

find_calibre_bin() {
  local bin="$1"
  local app_bin="${2:-/Applications/calibre.app/Contents/MacOS/$bin}"
  if command -v "$bin" >/dev/null 2>&1; then
    echo "$bin"
    return 0
  fi
  if [ -x "$app_bin" ]; then
    echo "$app_bin"
    return 0
  fi
  return 1
}

save_library_path() {
  local path="$1"
  if [ -f "$TOOLS_FILE" ]; then
    if grep -q '^calibre_library_path=' "$TOOLS_FILE"; then
      sed -i '' "s|^calibre_library_path=.*|calibre_library_path=${path}|" "$TOOLS_FILE" 2>/dev/null || \
      perl -0777 -pe "s|^calibre_library_path=.*|calibre_library_path=${path}|m" -i "$TOOLS_FILE"
    else
      printf '\ncalibre_library_path=%s\n' "$path" >> "$TOOLS_FILE"
    fi
  else
    printf '# Tool Configuration\ncalibre_library_path=%s\n' "$path" > "$TOOLS_FILE"
  fi
}

load_library_path() {
  local path=""
  if [ -n "${CALIBRE_LIB_PATH:-}" ]; then
    path="$CALIBRE_LIB_PATH"
  elif [ -n "${CALIBRE_LIBRARY_PATH:-}" ]; then
    path="$CALIBRE_LIBRARY_PATH"
  elif [ -f "$TOOLS_FILE" ]; then
    path="$(grep '^calibre_library_path=' "$TOOLS_FILE" | head -n1 | cut -d'=' -f2-)"
  elif [ -d "$HOME/Calibre Library" ]; then
    path="$HOME/Calibre Library"
  fi

  if [ -z "$path" ]; then
    echo "Error: Library path not set. Use --library-path or set CALIBRE_LIBRARY_PATH." >&2
    exit 1
  fi
  if [ ! -d "$path" ] || [ ! -f "$path/metadata.db" ]; then
    echo "Error: Invalid library path: $path (expected metadata.db)" >&2
    exit 1
  fi
  echo "$path"
}
