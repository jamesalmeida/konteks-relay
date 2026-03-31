# Proactive Work Checklist

## ⚡ Heartbeat Rules
- **Be fast.** Don't scan emails or do heavy I/O here — that's handled by cron jobs.
- If nothing needs attention, reply HEARTBEAT_OK immediately.
- Only act if something in this file is unchecked AND time-sensitive.

## Cron Jobs Handle These (don't duplicate)
- ✅ Email watch (3 accounts) → cron: "Email Watch" (8am/11am/2pm/5pm)
- ✅ Morning Brief → cron: "Morning Brief" (6:30am daily)
- ✅ Daily Summary → cron: "Daily Summary → Konteks" (midnight daily)
- ✅ Nightly Build → cron: "Nightly Build" (2am daily)
- ✅ Workspace backup → cron: "Daily workspace backup" (3am daily)
- ✅ Auto-update → cron: "Daily Auto-Update" (4am daily)

## 🎬 YouTube Partner Program — MONETIZED ✅ (Mar 12, 2026)
- Focus: consistent content posting (1-2 videos/week target)

## Ongoing Projects (background awareness, no action needed per heartbeat)
- Konteks PRs to test: #25, #28, #29, #30, #31, #32, #33
- App Store optimization research
- Consulting business growth
