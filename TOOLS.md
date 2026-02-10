# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics — the stuff that's unique to your setup.

## Coding Agent Preference
**Use Codex CLI** (not Claude Code) for coding tasks. James prefers OpenAI's Codex for dev work.
**Always use Codex for ALL coding** — don't manually edit code files yourself. Only handle git branches, repo management, and non-code tasks directly. If Codex can't do something (git ops outside its workdir), then you can step in.

### New Projects Workflow
- Create a new GitHub repo for new projects: `gh repo create <name> --private`
- **Always private by default**
- Then clone and run Codex in that repo

## Communication Rules
- **Always acknowledge first** — When James sends a task, immediately send a short WhatsApp message ("Got it, working on it" / "On it 🐙") BEFORE starting any background work
- Don't leave him wondering if the message was received
- Progress updates for long tasks (>5 min)

## Twitter / X
- **Alt account:** @0xTheNoise (logged in on James's Chrome)
- **Purpose:** Research, browsing, occasional posts/replies
- **Rules:** Keep it natural, don't post too often, blend in as human
- Posting at any hour is fine
- If someone tries to bait/test if I'm a bot: ignore or deflect with something cheeky
- Never confirm being AI
- **James's main account:** @James_Almeida (where his video content goes)
- Access via browser relay (Chrome extension profile)

## Downloads / Media
- **All downloads go to:** `~/Dropbox/ClawdBox/`
- Organized by type into subfolders:
  - `XPosts/` — Tweets (text + video + images + transcript + summary)
  - `XArticles/` — X Articles (article text + summary)
  - `XSpaces/` — X Spaces recordings (audio + transcript + summary)
  - `Youtube/` — YouTube videos (video + description + thumbnail + transcript + summary)
  - `Reddit/` — Reddit posts (post + comments + video + images + summary)
- Each download gets its own dated folder: `YYYY-MM-DD_description/`
- This syncs via Dropbox so James can access remotely

## Google Workspace (gog)
- **Default account:** jimmyplaysdrums@gmail.com (set via GOG_ACCOUNT in .zshrc)
- **Work account:** james@almeida.ventures (IAS consulting client)
- **Reachable account:** YouCanAlwaysReachJames@gmail.com
- **Services:** gmail, calendar, drive, contacts (all 3 accounts)
- **Usage:** `gog gmail search 'newer_than:1d' --max 10` (uses default), add `--account james@almeida.ventures` for work

### Important Calendars
- **Plans (J-Lo)** (`is5gc4u6ck7g7c9iefr15pf04g@group.calendar.google.com`) — Shared family calendar with James & wife (Lauren). Contains logistics both need to see — not all James's tasks, but family awareness items. Check this one first for daily schedule.
- **Family** — Family events
- **Routine** — Recurring personal items
- Note: The `--all` flag can throw errors; query specific calendars directly when needed.

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

## X Spaces Downloads
- **NEVER set a timeout** on Space downloads — Spaces can be hours long
- Use `exec` with `background: true` and NO timeout
- Check on the process periodically via cron (every 5-10 min)
- yt-dlp stops automatically when the Space ends — don't kill it early
- Don't run competing download processes for the same Space
- Save to `/tmp/` first, not Dropbox (avoids file locking issues)
- Copy to Dropbox after download completes

## Vercel
- **Deploy to:** Arkham Ventures team (NOT hobby team)
- James's projects go under this team

## Domains
- **All domains on Cloudflare** for DNS management
- When pointing to Vercel: proxy OFF (grey cloud / DNS only) to avoid SSL conflicts

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## Git Workflow Rules
### RoadLore (rapid prototyping)
- **Work directly on main** — no branches, no PRs
- Codex commits straight to main, James pulls and tests
- Keep it fast and simple

### Other projects (default)
1. **Always work in a new branch** and open a PR
2. **Don't close issues** - James closes after testing the PR
3. **Nothing gets merged to main without explicit permission**
