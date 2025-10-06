<img src="../docs/assets/bowl.png" alt="Bowl" width='200px'>

## Building Bowl Browser

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Command Line Tools

### Quick Start

#### Option 1: Xcode (Recommended for Development)

1. Open the project:
   ```bash
   cd macos
   open Bowl.xcodeproj
   ```

2. In Xcode:
   - Select "Bowl" scheme
   - Build and run (Cmd+R)

#### Option 2: Command Line

Build the app:
```bash
cd macos
xcodebuild -project Bowl.xcodeproj -scheme Bowl -configuration Release build
```

The app will be built to: `build/Release/Bowl.app`

#### Option 3: Build Script

```bash
./macos/build.sh
```

### Building the CLI

Build the `bowl` CLI tool:

```bash
cd macos
swift build -c release

# Copy to /usr/local/bin
sudo cp .build/release/bowl /usr/local/bin/
```

Or use the install script:
```bash
./macos/install.sh
```

### Installation

#### Manual Install

1. Build the app (see above)
2. Copy to Applications:
   ```bash
   cp -r build/Release/Bowl.app /Applications/
   ```
3. Install CLI:
   ```bash
   sudo cp .build/release/bowl /usr/local/bin/
   ```

#### Using the Install Script

```bash
./macos/install.sh
```

This will:
- Build Bowl.app
- Copy to /Applications
- Build and install bowl CLI
- Set up plugin directory (~/.bowl/plugins)
- Copy example config

### Usage

Launch Bowl:
```bash
bowl                          # Open blank browser
bowl https://github.com       # Open with URL
bowl github.com              # Auto-adds https://
bowl "rust tutorial"         # Search query
```

### Plugins

Install example plugins:
```bash
mkdir -p ~/.bowl/plugins
cp -r examples/plugins/* ~/.bowl/plugins/
```

Enable in config (`~/.bowl/config.toml`):
```toml
[plugins]
enabled = ["vim-mode", "ad-blocker"]
```

### Configuration

Config file: `~/.bowl/config.toml`

Copy example config:
```bash
mkdir -p ~/.bowl
cp examples/configs/config.toml ~/.bowl/
```

### Development

#### Hot Reload

For plugin development, enable dev mode in config:
```toml
[developer]
plugin_dev_mode = true
```

#### Debugging

- Enable Developer Extras in WKWebView (already enabled)
- Right-click in browser → Inspect Element
- View console logs in Xcode

### Code Signing

For distribution, you'll need to sign the app:

```bash
codesign --force --deep --sign "Developer ID Application: YOUR NAME" Bowl.app
```

### Troubleshoties

**App won't launch:**
- Check Console.app for errors
- Verify macOS version (13.0+)
- Try removing: `rm -rf ~/Library/Caches/com.bowl.browser`

**CLI not found:**
- Ensure `/usr/local/bin` is in PATH
- Try: `which bowl`

**Plugins not loading:**
- Check plugin directory: `ls ~/.bowl/plugins`
- Verify manifest.json format
- Enable plugin logs in config

### Bundle Size

Current unoptimized build: ~8MB
Target optimized build: <5MB

Optimization flags are in the Xcode project.
