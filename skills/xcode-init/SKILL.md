---
name: xcode-init
version: 1.0.0
author: tersono
description: Create new iOS SwiftUI projects via XcodeGen. Generates properly configured Xcode projects from CLI without manual setup. Use when scaffolding a new iOS app.
when: User asks to create a new iOS app, Swift project, or Xcode project
examples:
  - Create a new iOS app called MyApp
  - Scaffold an iOS SwiftUI project
  - Initialize a new Xcode project for RoadLore
tags:
  - ios
  - xcode
  - swift
  - swiftui
  - scaffold
metadata:
  openclaw:
    emoji: "📱"
    requires:
      bins: ["xcodegen"]
    install:
      - id: brew
        kind: brew
        formula: xcodegen
        bins: ["xcodegen"]
        label: Install XcodeGen (brew)
---

# xcode-init

Generate new iOS SwiftUI projects via XcodeGen CLI.

## Why

Codex/Claude-generated Xcode projects often have config issues. XcodeGen creates properly configured `.xcodeproj` files from a simple YAML spec, matching what Xcode would create natively.

## Usage

Run the init script with project details:

```bash
./skills/xcode-init/init.sh \
  --name "MyApp" \
  --bundle-id "com.example.myapp" \
  --dir "/path/to/project" \
  --ios-version "17.0" \
  --open
```

### Options

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--name` | Yes | - | Project/app name (e.g., "RoadLore") |
| `--bundle-id` | No | `com.example.<name>` | Bundle identifier |
| `--dir` | No | `./<name>` | Target directory |
| `--ios-version` | No | `17.0` | Minimum iOS deployment target |
| `--org` | No | - | Organization name for copyright |
| `--open` | No | false | Open in Xcode after generation |

## What It Creates

```
MyApp/
├── project.yml           # XcodeGen spec (keep this!)
├── MyApp.xcodeproj/      # Generated Xcode project
├── MyApp/
│   ├── App/
│   │   └── MyAppApp.swift
│   ├── Views/
│   │   └── ContentView.swift
│   ├── Models/
│   ├── Services/
│   ├── Resources/
│   │   └── Assets.xcassets/
│   └── Info.plist
└── README.md
```

## Regenerating

If you modify `project.yml` (add targets, change settings), just run:

```bash
cd /path/to/project
xcodegen generate
```

The `.xcodeproj` will be regenerated. Your source files are untouched.

## Example: Full iOS App Scaffold

```bash
# Create RoadLore project
./skills/xcode-init/init.sh \
  --name "RoadLore" \
  --bundle-id "com.jamesalmeida.roadlore" \
  --dir "$HOME/clawd/roadlore" \
  --ios-version "17.0" \
  --org "James Almeida" \
  --open
```

## Notes

- XcodeGen must be installed: `brew install xcodegen`
- Generated projects use SwiftUI lifecycle (no AppDelegate)
- Supports iOS 17+ by default (for latest SwiftUI features)
- `project.yml` is the source of truth — commit it, not the `.xcodeproj`
