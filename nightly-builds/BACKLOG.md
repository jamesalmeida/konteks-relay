# Nightly Build Backlog

## Rules
1. **Pick smart, not first.** Read today's memory file + recent session context to understand what James is actively working on, what's urgent, and what would be most useful tomorrow morning.
2. **Priority order:** 🚨 Urgent/deadline items → items related to today's active work → items that unblock other work → high-value PRs on real projects → everything else
3. **Prefer real PRs** on existing repos (Konteks, FastClaw, Actually Useful AI, Sheldn.ai) over standalone prototypes. James wants actual useful code, not demos.
4. **Dropbox demos are for experiments only** — tools James didn't ask for but might find cool. Max 1-2 per week.
5. Build using Codex CLI. Save build notes to `nightly-builds/YYYY-MM-DD/`
6. Check it off, commit, report what you built
7. Keep scope small — 1-2 hours max. Working > perfect.
8. If nothing on the backlog feels useful tonight, **skip the build** and say why. A skipped night > a wasted PR.

---

## Queue

### 🦞 Actually Useful AI / Sheldn.ai
- [ ] **Phase 6: Channel onboarding** — WhatsApp QR, Telegram bot, web chat embed
- [ ] **Secure admin panel** — Replace client-side password with Convex auth (#29)
- [ ] **Support email integration** — Help Scout or similar (#20)
- [ ] **Google OAuth for customers** — Let users sign up with Google (#19, #39)
- [ ] **Logos and branding** — Professional logos for landing page (#13)
- [ ] **Scarcity meter** — Show limited beta spots remaining (#12)

### 📱 Konteks iOS
- [x] **Issue triage bot** — Auto-label new GitHub issues ✅ (2026-04-07, PR #60: https://github.com/jamesalmeida/konteks-ios/pull/60)
- [ ] **Multi-gateway support** — Pair with multiple OpenClaw instances and switch between them (#40)
- [ ] **Close stale issues** — Many issues marked done in BACKLOG but still open in GitHub
- [ ] **Push notifications** — Notify on new messages when app is backgrounded (#2)
- [ ] **Shortcuts Support (App Intents)** — Siri shortcuts for common actions (#4)
- [ ] **Google Calendar Sync** — Two-way sync with Google Calendar (#5)
- [ ] **Recurring Tasks** — Support repeating tasks (#3)
- [ ] **Interactive Widgets** — Home screen widgets for Inbox, Today, Lists (#1)

### 📱 Konteks Web
- [ ] **Issue triage bot** — Same as iOS repo
- [ ] **Test infrastructure completion** — PR #121 is open, needs review/merge
- [ ] **API health dashboard** — Monitor Convex uptime and response times

### 🔧 DevOps & Tooling
- [x] **PR backlog dashboard** — Tool to track open PRs across all repos ✅ (2026-04-08, nightly-builds/scripts/)
- [ ] **Skill usage analytics** — Track which OpenClaw skills get used most
- [ ] **Session log analytics** — Dashboard for analyzing past sessions

### 🧪 Experiments (Dropbox only)
- [ ] None scheduled — prefer real PRs
