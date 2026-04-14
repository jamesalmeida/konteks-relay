# Nightly Build — April 14, 2026

## What Was Built

**Interactive Home Screen Widgets for Konteks iOS**

PR #64: https://github.com/jamesalmeida/konteks-ios/pull/64

## Why This Build

This completes the trifecta of "works without opening the app" — building on last week's App Intents (PR #62) and Push Notifications (PR #63). Interactive widgets are the #1 most requested feature on the repo (Issue #1) and the last major pillar of ambient task management.

The pattern has been:
- Shortcuts → capture without opening
- Notifications → be reminded without opening  
- Widgets → view and complete without opening

## What Was Delivered

### Widget Types
1. **Configurable Widget** — User picks Inbox, Today, or Anytime
2. **Inbox Widget** — Dedicated unfiled items view
3. **Today Widget** — Shows scheduled/due items + refreshes at midnight

### Features
- ✅ Tap-to-complete tasks directly from widget
- 📐 Small, Medium, Large sizes
- 🎯 Priority indicators (orange dot for high priority)
- 🕐 Due time display
- ✨ "All caught up!" empty state
- 🔄 Auto-refresh every 15 minutes

### Technical Implementation
- **App Groups** — `group.com.arkhamventures.konteks` for data sharing
- **ItemService.syncItemsToWidget()** — Syncs on every CRUD operation
- **WidgetDataProvider** — Timeline provider reading from shared container
- **CompleteTaskIntent** — AppIntent for interactive completion

## Files Created/Modified

```
ios/Konteks/KonteksWidget/
├── WidgetModels.swift          # Codable models for widget
├── WidgetDataProvider.swift    # Timeline provider + configuration
├── KonteksWidget.swift         # Configurable widget + all views
├── InboxWidget.swift           # Dedicated inbox widget
├── TodayWidget.swift           # Dedicated today widget
├── CompleteTaskIntent.swift    # AppIntent for completion
├── KonteksWidgetBundle.swift   # Widget bundle entry
├── Info.plist                  # Widget extension plist
└── README.md                   # Setup instructions

ios/Konteks/Konteks/Services/ItemService.swift
├── Added WidgetKit import
├── Added sharedDefaults for App Groups
├── Added syncItemsToWidget() method
├── Added sync calls after all CRUD operations
```

## Setup Required (Manual)

Since we can't modify `.pbxproj` via code:

1. Open `Konteks.xcodeproj` in Xcode
2. Add **App Groups** capability to main app target: `group.com.arkhamventures.konteks`
3. **File → New → Target → Widget Extension** → Name: `KonteksWidget`
4. Add **App Groups** capability to widget target (same group)
5. Add all widget files to the widget target

Full instructions in `KonteksWidget/README.md`

## Time Spent

~1.5 hours — scope was well-contained and built on existing patterns.

## Notes

- Widgets use cached data from App Groups (no Supabase access)
- Main app must be opened once to populate widget data
- Widget completion updates shared container immediately
- Server sync happens when main app next launches
- Today widget has special midnight refresh logic
