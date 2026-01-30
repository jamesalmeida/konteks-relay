# Nightly Builds 🌙

Small tools and improvements built while James sleeps.

Every night at 2am, I pick one small pain point in our workflow and build something to fix it.

## Builds

### 2026-01-29: Project Dashboard 🐙 (v2)
**The first nightly build — upgraded!**

A comprehensive project tracking dashboard featuring:
- **Animated SVG Octopus** — Tersono with bobbing head, waving tentacles, blinking eyes, ZZZ sleep mode
- **Project Health Bar** — At-a-glance status for Konteks iOS, Mercury Rx, Memex, Stranger Danger
- **App Buildouts** — Live GitHub PR/issue tracking (7 Konteks PRs, 1 Mercury PR, 3 Mercury issues)
- **Tersono Improvements** — Skills and tools backlog
- **Video Ideas** — YouTube & X content pipeline
- **X.com Posts** — Post ideas and drafts
- **Add Item Modal** — Clean modal for adding new items from the dashboard
- **Status Legend** — PR / Issue / Draft / Idea / Done indicators

**Usage:**
```bash
open nightly-builds/2026-01-29/index.html
# Or refresh GitHub data:
./nightly-builds/2026-01-29/refresh.sh
```

**v2 improvements over v1:**
- SVG octopus with proper eyes, blinking, sleeping Zzz, and glow pulse
- Project health summary cards with repo links
- Add-item modal (not just prompt())
- Better color system and responsive layout
- Correct GitHub repo URLs (konteks-ios, mercuryRx)
- New PR #33 (resilient login fix) included
- "Done" stat counter for completed items

---

## Ideas Backlog

**Priority:**
- [x] 🔐 **stranger-danger** — Published to ClawdHub & GitHub ✅
- [ ] Review @mrnacknack's Clawdbot security article for hardening ideas

**Dashboard Future Features:**
- [ ] 📊 YouTube Analytics — channel stats, video performance, subscriber growth
- [ ] 🐦 X/Twitter Analytics — engagement, follower trends, post performance
- [ ] 🤖 Tersono Usage Tracking — API calls, model usage breakdown, cost tracking per model
- [ ] 🔄 Auto-refresh via cron (update data.json nightly with gh CLI data)

**Skills to Build:**
- [ ] 🧠 **smart-router** — Auto-route tasks to cheaper models when Opus isn't needed
  - Analyze task complexity before execution
  - Simple tasks → Sonnet/Haiku/GPT-4o-mini
  - Complex tasks → Opus
  - Track savings & usage by model
  - Help James stay within monthly limits

**Tools to Build:**
- [ ] Daily summary generator for memory files
- [ ] GitHub issue triager
- [ ] App Store review monitor
- [ ] Session transcript summarizer
- [ ] Quick-capture CLI for ideas
- [ ] Memory defragmenter/organizer

---

*Each build lives in its own dated folder (YYYY-MM-DD/) with source code and usage instructions.*
