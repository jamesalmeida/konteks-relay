#!/bin/bash
# Log an agent activity event to Supabase
# Usage: ./log-agent-activity.sh <event_type> <description> [metadata_json]
#
# Event types: heartbeat, session, cron, task_completed, codex_run, transcription, model_change, error
#
# Examples:
#   ./log-agent-activity.sh heartbeat "Heartbeat check - all clear"
#   ./log-agent-activity.sh codex_run "Started Codex on konteks-web #82" '{"repo":"konteks-web","issue":82}'

set -euo pipefail

EVENT_TYPE="${1:?Usage: log-agent-activity.sh <event_type> <description> [metadata_json]}"
DESCRIPTION="${2:?}"
METADATA="${3:-\{\}}"

ENV_FILE="/Users/james/dev/konteks-web/.env.local"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found" >&2
  exit 1
fi

SUPABASE_URL=$(grep '^NEXT_PUBLIC_SUPABASE_URL=' "$ENV_FILE" | cut -d= -f2-)
SUPABASE_KEY=$(grep '^SUPABASE_SECRET_KEY=' "$ENV_FILE" | cut -d= -f2-)
USER_ID="5d08b618-e143-4e03-affd-1dcca152012a"

# Build JSON payload safely with python3
PAYLOAD=$(python3 -c "
import json, sys
print(json.dumps({
    'user_id': '${USER_ID}',
    'event_type': sys.argv[1],
    'description': sys.argv[2],
    'metadata': json.loads(sys.argv[3])
}))
" "$EVENT_TYPE" "$DESCRIPTION" "$METADATA")

curl -sS "${SUPABASE_URL}/rest/v1/agent_activity" \
  -H "apikey: ${SUPABASE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d "$PAYLOAD"
