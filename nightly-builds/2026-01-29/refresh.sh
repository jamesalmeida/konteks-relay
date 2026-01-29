#!/bin/bash
# Refresh dashboard data from GitHub
# Run this to update data.json with latest PR/issue counts

set -e
cd "$(dirname "$0")"

echo "🐙 Refreshing dashboard data..."

# Fetch Konteks PRs
KONTEKS_PRS=$(gh pr list -R jamesalmeida/konteks --state open --json number,title | jq 'length')
echo "   Konteks PRs: $KONTEKS_PRS"

# Fetch Konteks Issues  
KONTEKS_ISSUES=$(gh issue list -R jamesalmeida/konteks --state open --json number | jq 'length')
echo "   Konteks Issues: $KONTEKS_ISSUES"

# Fetch Mercury Rx PRs
MERCURY_PRS=$(gh pr list -R jamesalmeida/mercuryRx --state open --json number | jq 'length')
echo "   Mercury Rx PRs: $MERCURY_PRS"

# Generate updated data.json
# Note: This is a simplified refresh - for full data, edit data.json directly
# or have Tersono update it via the Clawdbot interface

echo ""
echo "📊 Summary:"
echo "   Total Open PRs: $((KONTEKS_PRS + MERCURY_PRS))"
echo "   Total Open Issues: $KONTEKS_ISSUES"
echo ""
echo "✅ To fully update data.json, ask Tersono to refresh the dashboard data."
echo "   The web UI also supports adding items manually."
