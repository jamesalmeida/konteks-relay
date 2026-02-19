#!/usr/bin/env bash
set -euo pipefail

LABEL="com.fastclaw.relay"
PLIST_NAME="$LABEL.plist"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_PATH="$SCRIPT_DIR/$PLIST_NAME"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
TARGET_PATH="$LAUNCH_AGENTS_DIR/$PLIST_NAME"
LOG_DIR="$HOME/.openclaw/fastclaw/logs"
NODE_PATH="$(command -v node || true)"

if [[ -z "$NODE_PATH" ]]; then
  echo "Error: node is not installed or not in PATH"
  exit 1
fi

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "Error: missing template at $TEMPLATE_PATH"
  exit 1
fi

mkdir -p "$LAUNCH_AGENTS_DIR"
mkdir -p "$LOG_DIR"

SKILL_DIR_ESCAPED="$(printf '%s' "$SKILL_DIR" | sed 's/[\\/&]/\\&/g')"
NODE_PATH_ESCAPED="$(printf '%s' "$NODE_PATH" | sed 's/[\\/&]/\\&/g')"
LOG_DIR_ESCAPED="$(printf '%s' "$LOG_DIR" | sed 's/[\\/&]/\\&/g')"

cp "$TEMPLATE_PATH" "$TARGET_PATH"
sed -i '' \
  -e "s/SKILL_DIR/$SKILL_DIR_ESCAPED/g" \
  -e "s/NODE_PATH/$NODE_PATH_ESCAPED/g" \
  -e "s|~/.openclaw/fastclaw/logs|$LOG_DIR_ESCAPED|g" \
  "$TARGET_PATH"

launchctl bootout "gui/$UID" "$TARGET_PATH" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$UID" "$TARGET_PATH"
launchctl enable "gui/$UID/$LABEL" >/dev/null 2>&1 || true
launchctl kickstart -k "gui/$UID/$LABEL" >/dev/null 2>&1 || true

echo "Installed launch agent: $TARGET_PATH"
echo "Relay logs:"
echo "  stdout: $LOG_DIR/relay.out.log"
echo "  stderr: $LOG_DIR/relay.err.log"

echo
echo "launchctl list status:"
if launchctl list | grep -F "$LABEL"; then
  true
else
  echo "Warning: $LABEL not found in launchctl list"
fi
