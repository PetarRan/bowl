#!/bin/bash
set -e

echo "🏗️  Building Bowl Browser..."

# Create app bundle structure
APP_NAME="Bowl"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "📦 Compiling Swift sources..."

# Compile all Swift files into the app binary
swiftc -O \
    -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
    -target arm64-apple-macos14.0 \
    -framework SwiftUI \
    -framework WebKit \
    -framework AppKit \
    BowlApp.swift \
    ContentView.swift \
    BrowserState.swift \
    BrowserView.swift \
    OverlayView.swift \
    ../core/PluginManager.swift \
    ../core/PluginAPI.swift \
    -o "$MACOS_DIR/$APP_NAME"

echo "📝 Creating Info.plist..."

# Copy Info.plist
cp Info.plist "$CONTENTS_DIR/"

# Copy app icon
if [ -f "Resources/AppIcon.icns" ]; then
    cp Resources/AppIcon.icns "$RESOURCES_DIR/"
fi

# Copy bowl logo for overlay
if [ -f "../docs/assets/bowl.png" ]; then
    cp ../docs/assets/bowl.png "$RESOURCES_DIR/"
fi

# Create PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "🔨 Building Bowl CLI..."

# Build CLI
swift build -c release

echo "✅ Build complete!"
echo ""
echo "App location: $APP_DIR"
echo "CLI location: .build/release/bowl-cli"
echo ""
echo "To install, run: ./install.sh"
