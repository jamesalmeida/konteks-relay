# Nightly Builds 🌙

Small tools and improvements built while James sleeps.

Every night at 2am, I pick one small pain point in our workflow and build something to fix it using Codex CLI.

## Builds

### 2026-01-29: Project Dashboard 🐙
**The first nightly build!**

A comprehensive project tracking dashboard featuring:
- **Animated Octopus Avatar** — Tersono's spirit animal with 4 states (working, idle, thinking, sleeping)
- **App Buildouts** — Real-time GitHub PR/issue tracking for Konteks, Mercury Rx, Memex
- **Tersono Improvements** — Skills and tools backlog
- **Video Ideas** — YouTube & X content pipeline
- **X.com Posts** — Post ideas and drafts

**Usage:**
```bash
open nightly-builds/2026-01-29/index.html
```

**Features:**
- Auto-detects time of day for octopus status
- Click status links in footer to test animations
- Add items directly via UI buttons
- Data persists in localStorage + data.json
- Run `refresh.sh` to check GitHub counts

---

## Ideas Backlog

**Priority:**
- [ ] 🔐 **stranger-danger** — Challenge-response identity verification
  - Store hashed answers in macOS Keychain
  - Package as shareable Clawdbot skill  
  - X post: "Give your Clawd a safe word with Stranger-Danger 🚨"
  - 🚧 **IN PROGRESS** — Codex building now
- [ ] Review @mrnacknack's Clawdbot security article for hardening ideas

**Dashboard Future Features:**
- [ ] 📊 YouTube Analytics — channel stats, video performance, subscriber growth
- [ ] 🐦 X/Twitter Analytics — engagement, follower trends, post performance
- [ ] 🤖 Tersono Usage Tracking — API calls, model usage breakdown, cost tracking per model

**Skills to Build:**
- [ ] 🧠 **smart-router** — Auto-route tasks to cheaper models when Opus isn't needed
  - Analyze task complexity before execution
  - Simple tasks → Sonnet/Haiku/GPT-4o-mini
  - Complex tasks → Opus
  - Track savings & usage by model
  - Help James stay within monthly limits

**Tools to build:**
- [ ] Quick PR status checker for Konteks/mercuryRx
- [ ] Daily summary generator for memory files
- [ ] GitHub issue triager
- [ ] App Store review monitor
- [ ] Session transcript summarizer
- [ ] Quick-capture CLI for ideas
- [ ] Memory defragmenter/organizer

---

*Each build lives in its own dated folder (YYYY-MM-DD/) with source code and usage instructions.*
