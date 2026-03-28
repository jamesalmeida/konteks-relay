#!/usr/bin/env bash
# Syncs Limitless lifelogs to Obsidian vault
# Fetches from last synced date up to today

API_KEY="sk-da2d0026-881a-4efd-88cb-aec8b1bfef21"
VAULT_DIR="/Users/james/Obsidian-Vault/3 - Resources/Limitless Lifelogs"
TZ_NAME="America/Los_Angeles"
BASE_URL="https://api.limitless.ai/v1/lifelogs"

mkdir -p "$VAULT_DIR"

# Find last synced date
LAST=$(ls "$VAULT_DIR"/*.md 2>/dev/null | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sort | tail -1)
if [ -z "$LAST" ]; then
  START="2025-02-10"
else
  START="$LAST"
fi

TODAY=$(date +%Y-%m-%d)
echo "Syncing from $START to $TODAY..."

d="$START"
while true; do
  # Compare dates as strings (YYYY-MM-DD sorts lexicographically)
  if [[ "$d" > "$TODAY" ]]; then
    break
  fi

  FILE="$VAULT_DIR/$d.md"
  CURSOR=""
  CONTENT=""

  while true; do
    URL="${BASE_URL}?date=${d}&timezone=${TZ_NAME}&includeMarkdown=true&includeHeadings=true&direction=asc&limit=10"
    [ -n "$CURSOR" ] && URL="${URL}&cursor=${CURSOR}"

    RESPONSE=$(curl -s -H "X-API-Key: $API_KEY" "$URL")
    ENTRIES=$(echo "$RESPONSE" | python3 -c "
import json,sys
data = json.load(sys.stdin)
lifelogs = data.get('data', {}).get('lifelogs', [])
for log in lifelogs:
    md = log.get('markdown', '')
    if md:
        print(md.replace('\\\n', '\n'))
" 2>/dev/null)

    NEXT=$(echo "$RESPONSE" | python3 -c "
import json,sys
data = json.load(sys.stdin)
print(data.get('meta', {}).get('lifelogs', {}).get('nextCursor', '') or '')
" 2>/dev/null)

    if [ -n "$ENTRIES" ]; then
      CONTENT="${CONTENT}${ENTRIES}"$'\n'
    fi

    [ -z "$NEXT" ] && break
    CURSOR="$NEXT"
  done

  if [ -n "$CONTENT" ]; then
    echo "$CONTENT" > "$FILE"
    echo "  ✅ $d"
  else
    echo "  — $d (no entries)"
  fi

  d=$(date -j -v+1d -f "%Y-%m-%d" "$d" +%Y-%m-%d)
done

echo "Sync complete."
