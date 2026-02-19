#!/usr/bin/env bash
set -euo pipefail

LABEL="com.fastclaw.relay"
PLIST_NAME="$LABEL.plist"
TARGET_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"

launchctl bootout "gui/$UID" "$TARGET_PATH" >/dev/null 2>&1 || true
launchctl disable "gui/$UID/$LABEL" >/dev/null 2>&1 || true

if [[ -f "$TARGET_PATH" ]]; then
  rm -f "$TARGET_PATH"
  echo "Removed launch agent: $TARGET_PATH"
else
  echo "Launch agent not found: $TARGET_PATH"
fi

echo
echo "launchctl list status:"
if launchctl list | grep -F "$LABEL"; then
  echo "Warning: $LABEL is still listed"
else
  echo "$LABEL is not loaded"
fi
