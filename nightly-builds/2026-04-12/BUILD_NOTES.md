# Nightly Build — 2026-04-12

## What: Push Notifications Infrastructure (PR #63)
- **Repo:** konteks-ios
- **Branch:** `feat/push-notifications`
- **PR:** https://github.com/jamesalmeida/konteks-ios/pull/63
- **Issue:** #2 (Push Notifications)

## Why This Tonight
Last night's build (#62) added App Intents/Siri Shortcuts. Push notifications is the other major "works without opening the app" pillar from DESIGN.md. Together with Shortcuts (#62), this gives Konteks real iOS platform citizenship — users don't need the app open to interact with their tasks. Push notifications is arguably the #1 missing feature for any task management app.

## What Was Built

### New Files (2)
- `ios/Konteks/Konteks/Services/NotificationService.swift` (517 lines)
  - `@MainActor` singleton, `UNUserNotificationCenterDelegate`
  - Local notification scheduling keyed by item UUID
  - Complete + Snooze action buttons
  - Quiet hours with overnight wraparound
  - Badge count tracking (inbox items)
  - Smart date normalization (date-only → 9 AM default)
  
- `ios/Konteks/Konteks/Models/NotificationSettings.swift` (45 lines)
  - Codable UserDefaults persistence
  - Master toggle, per-type toggles, quiet hours, snooze duration

### Modified Files (3)
- `SettingsView.swift` — Full notification settings UI replacing stub toggles
- `ItemService.swift` — Notification hooks in all lifecycle methods + new `fetchItem(id:)`
- `KonteksApp.swift` — Delegate setup + configure on launch

### Total: 746 insertions, 6 deletions

## What's NOT Included (Follow-up)
- Remote push notifications (APNs for "AI plan ready") — needs backend work
- Inbox alert notifications (setting exists but no trigger mechanism yet)
- Deep linking from notification tap to specific item view

## Build Tool
- Codex CLI (`--full-auto`)
- ~202K tokens used
