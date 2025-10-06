<img src="../docs/assets/bowl.png" alt="Bowl" width='200px'>

## What is Bowl?

Bowl is a minimal, hackable, open source browser. It features:

- **Zero UI by default** - just a webview, no toolbars
- **Overlay control** - press Cmd+B to access all features
- **Terminal-friendly** - launch with `bowl <url>`
- **Plugin-powered** - customize everything
- **Privacy-first** - no telemetry, local-first

## Installation

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+ (for building)

### Build & Install

```bash
cd macos
./build.sh      # Build Bowl.app and CLI
./install.sh    # Install to /Applications
```

Or manually:

```bash
cd macos
xcodebuild -project Bowl.xcodeproj -scheme Bowl -configuration Release
cp -r build/Release/Bowl.app /Applications/
swift build -c release
sudo cp .build/release/bowl /usr/local/bin/
```

## Usage

### Launch Bowl

```bash
# Open blank browser
bowl

# Open with URL
bowl https://github.com

# Auto-adds https://
bowl github.com

# Search query
bowl "rust tutorial"
```

### Keyboard Shortcuts

- **Cmd+B** - Toggle overlay (your control center)
- **ESC** - Close overlay
- **Cmd+T** - New tab (when overlay is open)
- **Cmd+W** - Close tab

### The Overlay

Press **Cmd+B** to open the overlay. From here you can:

- Search or enter URLs
- See all open tabs
- Create/close tabs
- Navigate back/forward
- Reload page

The overlay is your browser's control center. Everything happens here.

## Configuration

Bowl stores config at `~/.bowl/config.toml`

```toml
[general]
homepage = "about:blank"
search_engine = "duckduckgo"

[keybindings]
toggle_overlay = "Cmd+B"

[plugins]
enabled = ["vim-mode", "ad-blocker"]
```

Edit this file to customize Bowl's behavior.

## Plugins

### Installing Plugins

Plugins go in `~/.bowl/plugins/`:

```bash
# Example: Install vim mode plugin
cp -r examples/plugins/vim-mode ~/.bowl/plugins/
```

Enable in config:

```toml
[plugins]
enabled = ["vim-mode"]
```

### Available Plugins

**vim-mode** - Navigate with vim keys (j/k/h/l)

- `j` - Scroll down
- `k` - Scroll up
- `h` - Go back
- `l` - Go forward
- `r` - Reload
- `t` - New tab

**ad-blocker** - Remove ads from pages

### Creating Plugins

See `examples/plugins/README.md` for plugin development guide.

Simple plugin example:

```javascript
// ~/.bowl/plugins/my-plugin/plugin.js
(function () {
  console.log("My plugin loaded!");

  // Use Bowl API
  window.bowl.notify("Hello from my plugin!");

  // Add keyboard shortcut
  document.addEventListener("keydown", (e) => {
    if (e.key === "x") {
      window.bowl.newTab("https://example.com");
    }
  });
})();
```

## Tips & Tricks

### Localhost Development

Just type `localhost:3000` and Bowl handles the rest.

### Instances

Launching `bowl <url>` when Bowl is running opens the URL in the existing window.

### Fast Navigation

Use the overlay search - it's faster than typing in a traditional URL bar:

1. Cmd+B
2. Type URL or search
3. Enter

### Session Management (Coming Soon)

```bash
bowl save my-session
bowl restore my-session
```

## Troubleshooting

### Bowl won't launch

- Check macOS version: System Settings → About
- Try: `rm -rf ~/Library/Caches/com.bowl.browser`

### CLI not found

- Verify installation: `which bowl`
- Add to PATH: `echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc`

### Plugins not working

- Check: `ls ~/.bowl/plugins`
- Verify manifest.json syntax
- Look for errors: Console.app → search "Bowl"

### Overlay not appearing

- Try Cmd+Shift+B
- Check config keybinding
- Restart Bowl

## Next Steps

- Read `/docs/ARCHITECTURE.md` to understand how Bowl works
- Check `/docs/ROADMAP.md` for upcoming features
- Browse `/examples/plugins/` for plugin ideas
- Join discussions on GitHub

## Philosophy

Bowl is designed to be:

- **Light** - Fast startup, low memory
- **Hackable** - Everything is customizable
- **Distraction-free** - No UI unless you want it
- **Local-first** - Your data stays on your machine
- **Open source** - MIT licensed, fork and modify

Enjoy your minimal browsing experience! 🍜
