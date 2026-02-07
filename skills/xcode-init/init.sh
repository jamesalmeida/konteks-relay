#!/bin/bash
set -e

# xcode-init: Generate iOS SwiftUI projects via XcodeGen
# Usage: ./init.sh --name "MyApp" --bundle-id "com.example.myapp" [options]

# Defaults
IOS_VERSION="17.0"
OPEN_XCODE=false
ORG_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --bundle-id)
      BUNDLE_ID="$2"
      shift 2
      ;;
    --dir)
      PROJECT_DIR="$2"
      shift 2
      ;;
    --ios-version)
      IOS_VERSION="$2"
      shift 2
      ;;
    --org)
      ORG_NAME="$2"
      shift 2
      ;;
    --open)
      OPEN_XCODE=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 --name <name> [--bundle-id <id>] [--dir <path>] [--ios-version <ver>] [--org <name>] [--open]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate required args
if [[ -z "$PROJECT_NAME" ]]; then
  echo "Error: --name is required"
  exit 1
fi

# Set defaults based on project name
BUNDLE_ID="${BUNDLE_ID:-com.example.$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')}"
PROJECT_DIR="${PROJECT_DIR:-./$PROJECT_NAME}"

# Check for xcodegen
if ! command -v xcodegen &> /dev/null; then
  echo "Error: xcodegen not found. Install with: brew install xcodegen"
  exit 1
fi

echo "📱 Creating iOS project: $PROJECT_NAME"
echo "   Bundle ID: $BUNDLE_ID"
echo "   Directory: $PROJECT_DIR"
echo "   iOS Target: $IOS_VERSION"

# Create directory structure
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/App"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Views"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Models"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Services"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Resources/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Resources/Assets.xcassets/AccentColor.colorset"

# Create project.yml (XcodeGen spec)
cat > "$PROJECT_DIR/project.yml" << EOF
name: $PROJECT_NAME
options:
  bundleIdPrefix: ${BUNDLE_ID%.*}
  deploymentTarget:
    iOS: "$IOS_VERSION"
  xcodeVersion: "15.0"
  generateEmptyDirectories: true

settings:
  base:
    MARKETING_VERSION: "1.0.0"
    CURRENT_PROJECT_VERSION: "1"
    DEVELOPMENT_TEAM: ""
    CODE_SIGN_STYLE: Automatic

targets:
  $PROJECT_NAME:
    type: application
    platform: iOS
    sources:
      - path: $PROJECT_NAME
        excludes:
          - "**/.DS_Store"
    settings:
      base:
        INFOPLIST_FILE: $PROJECT_NAME/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: $BUNDLE_ID
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
    info:
      path: $PROJECT_NAME/Info.plist
      properties:
        UILaunchScreen: {}
        UISupportedInterfaceOrientations:
          - UIInterfaceOrientationPortrait
          - UIInterfaceOrientationLandscapeLeft
          - UIInterfaceOrientationLandscapeRight
        UISupportedInterfaceOrientations~ipad:
          - UIInterfaceOrientationPortrait
          - UIInterfaceOrientationPortraitUpsideDown
          - UIInterfaceOrientationLandscapeLeft
          - UIInterfaceOrientationLandscapeRight
EOF

# Create App entry point
cat > "$PROJECT_DIR/$PROJECT_NAME/App/${PROJECT_NAME}App.swift" << EOF
import SwiftUI

@main
struct ${PROJECT_NAME}App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

# Create ContentView
cat > "$PROJECT_DIR/$PROJECT_NAME/Views/ContentView.swift" << EOF
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, $PROJECT_NAME!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
EOF

# Create Info.plist
cat > "$PROJECT_DIR/$PROJECT_NAME/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>\$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>\$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>\$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>\$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>\$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>\$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>\$(CURRENT_PROJECT_VERSION)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
    </dict>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
</dict>
</plist>
EOF

# Create Assets.xcassets Contents.json
cat > "$PROJECT_DIR/$PROJECT_NAME/Resources/Assets.xcassets/Contents.json" << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AppIcon.appiconset Contents.json
cat > "$PROJECT_DIR/$PROJECT_NAME/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" << EOF
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AccentColor.colorset Contents.json
cat > "$PROJECT_DIR/$PROJECT_NAME/Resources/Assets.xcassets/AccentColor.colorset/Contents.json" << EOF
{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Run xcodegen
echo "🔧 Generating Xcode project..."
cd "$PROJECT_DIR"
xcodegen generate

echo "✅ Project created: $PROJECT_DIR/$PROJECT_NAME.xcodeproj"

# Open in Xcode if requested
if [[ "$OPEN_XCODE" == true ]]; then
  echo "🚀 Opening in Xcode..."
  open "$PROJECT_NAME.xcodeproj"
fi

echo ""
echo "Next steps:"
echo "  1. Open $PROJECT_NAME.xcodeproj in Xcode"
echo "  2. Select your Development Team in Signing & Capabilities"
echo "  3. Build and run!"
