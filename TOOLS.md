# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics — the stuff that's unique to your setup.

## Coding Agent Preference
**Use Codex CLI** (not Claude Code) for coding tasks. James prefers OpenAI's Codex for dev work.

### New Projects Workflow
- Create a new GitHub repo for new projects: `gh repo create <name> --private`
- **Always private by default**
- Then clone and run Codex in that repo

## What Goes Here

Things like:
- Camera names and locations
- SSH hosts and aliases  
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH
- home-server → 192.168.1.100, user: admin

### TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## Git Workflow Rules (CRITICAL)
1. **NEVER merge to main** unless James specifically asks
2. **Always work in a new branch** and open a PR
3. **Don't close issues** - James closes after testing the PR
4. **Nothing gets merged to main without explicit permission**
5. When spawning Claude Code for dev work:
   - `git checkout -b feature/issue-name`
   - Commit to the branch
   - `gh pr create`
   - Do NOT close the issue
   - Wait for James to review, test, and merge
