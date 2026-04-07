# Nightly Build — 2026-04-07

## What I Built
**Automated Issue Triage Bot** for Konteks iOS

## Why This Build
James has been actively fixing Konteks iOS issues (7 PRs in the last 2 weeks). The GitHub repo has 17+ open issues with inconsistent labeling — this bot brings order without manual work, freeing James to focus on building instead of organizing.

## PR
- **konteks-ios#60**: https://github.com/jamesalmeida/konteks-ios/pull/60

## What It Does
Auto-labels new issues based on content analysis:
- **Platform**: ios, relay, web
- **Type**: bug, enhancement  
- **Priority**: high (for crash/security/urgent terms)
- **Area**: chat, pairing, auth, ui

## Technical Details
- GitHub Action workflow triggered on issues:opened/edited
- Uses actions/github-script for lightweight execution
- No external API calls or secrets needed
- Runs in ~2 seconds

## Files Changed
- `.github/workflows/triage.yml` (new file, 74 lines)

## Time Spent
~45 minutes

## Next Steps (for James)
1. Merge PR
2. Test by opening an issue with text like "Bug: crash when sending images on iOS"
3. Watch it auto-label

## What Was Attempted First
Originally tried to fix Issue #48 (image attachments), but discovered the fix was already in the konteks-relay repo — the local clone was tracking the wrong remote (tersono-backup instead of konteks-relay). After syncing with origin/main, the image attachment support was already complete. Pivoted to the triage bot instead.
