# 2026-04-11 — Nightly Build

## Shipped
**PR #62** on konteks-ios: App Intents / Siri Shortcuts scaffolding
https://github.com/jamesalmeida/konteks-ios/pull/62

Branch: `feat/app-intents-quick-capture`
Base: `main`
Commit: `5decb36`

## Why this one
- James's `DESIGN.md` explicitly calls Shortcuts a core principle ("works without opening the app") and dedicates a whole Voice Capture flow to it
- Issue #4 was an open `enhancement` that nobody had touched — zero conflict with the 7+ active `feature/issue-*` branches
- Konteks is James's flagship, and a real user-facing PR > another DevOps script (4th nightly in a row of triage/issue bots would've been samey)
- Scoped tight: new files only in a new folder + ~15 line hook in `KonteksApp.swift`
- James can review and understand it in <5 minutes
- Unblocks follow-up PRs (ShowToday, AddTask, Action Button quick-capture)

## What's in the PR
6 files changed, +151/-3:

- `ios/Konteks/Konteks/Features/Intents/QuickCaptureIntent.swift` — text → queue, `openAppWhenRun = false`
- `ios/Konteks/Konteks/Features/Intents/OpenKonteksIntent.swift` — simple launcher
- `ios/Konteks/Konteks/Features/Intents/KonteksAppShortcuts.swift` — `AppShortcutsProvider` with phrases & SF Symbols
- `ios/Konteks/Konteks/Features/Intents/PendingCaptureQueue.swift` — thread-safe UserDefaults-backed queue
- `ios/Konteks/Konteks/Features/Intents/README.md` — handoff pattern docs + TODO list
- `ios/Konteks/Konteks/KonteksApp.swift` — drain hook on `scenePhase .active`, logs captures (send path left as TODO)

## Architecture decision: pending queue pattern
App Intents run in a **separate process** but the **same app target**, so `UserDefaults.standard` is shared. Intent writes → app drains on activation. This dodges two failure modes:

1. iOS time-budgets intent processes — a network call inside `perform()` can get killed
2. User might have no network when triggering the shortcut — UserDefaults persists through reboots

The actual send-to-Convex wiring is explicitly left out so James can review the *pattern* before committing to it. One small follow-up PR will hook `drainPendingCaptures()` → `ConvexOpenClawClient.sendMessage` once he approves.

## De-risking
- **No project.pbxproj edit.** Konteks uses synchronized file groups (`objectVersion = 77`, Xcode 16+). New `.swift` files in the target directory are auto-picked up. This was the #1 risk going in.
- **No dependency changes.** `AppIntents` is a system framework autolinked by `import AppIntents` on iOS 16+.
- **No Info.plist / entitlements changes.** The basic scaffolding doesn't need them yet.
- **Zero overlap with in-flight branches.** Only touches `Features/Intents/` (new folder) + one scoped edit to `KonteksApp.swift`.
- **No build attempted.** Codex wrote code only — no Xcode on this host anyway. James will build on open.

## Tooling
- **Codex CLI** (`gpt-5.2-codex` default), `--full-auto`
- Background session: `tidal-shoal`
- Total tokens: ~65k
- Wall time: ~2 min for the code; another ~3 min for review/commit/push/PR
- `openclaw system event` notify failed at the end (gateway ws 1006 on 127.0.0.1:18789) but that's a local notification thing, not a build issue

## Follow-ups (for James, or next nightly)
- [ ] Wire `drainPendingCaptures` → `ConvexOpenClawClient.sendMessage` using `PairingState` + most-recent session
- [ ] Add `ShowToday`, `AddTask` (with `ProjectEntity` param), `CompleteTask` intents
- [ ] Action Button quick-capture flow (iPhone 15 Pro+)
- [ ] Voice → on-device transcription → queue
- [ ] Widget integration reusing the same `PendingCaptureQueue`

## Backlog state
- Konteks iOS: 3/10 done (#60 triage, #61 stale-close, #62 app-intents-scaffold)
- Konteks Web: 1/3 done (#122 triage)
- Sheldn.ai: 0/6 touched
