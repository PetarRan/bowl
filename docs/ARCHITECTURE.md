<img src="../docs/assets/bowl.png" alt="Bowl" width='200px'>

## Bowl Browser Architecture - Overview

> Proper documentation webpages coming soon ...

Bowl is a minimal, hackable browser built for developers. It follows a "zero UI by default" philosophy with all controls accessible through an overlay interface.

## Core Principles

1. **Minimal by default** - No toolbars, or UI unless explicitly you want
2. **Overlay-driven** - Steam-inspired overlay for all navigation
3. **Plugin-first** - Everything beyond basic browsing is a plugin
4. **Terminal-friendly** - Launch and control via CLI
5. **Local-first** - No telemetry, all data stays local

## Architecture Layers

```
┌─────────────────────────────────────┐
│        CLI (bowl command)           │
├─────────────────────────────────────┤
│       macOS App (Swift/SwiftUI)     │
│  ┌───────────────────────────────┐  │
│  │     Overlay UI (SwiftUI)      │  │
│  ├───────────────────────────────┤  │
│  │   WKWebView (Zero Chrome)     │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│      Plugin System (JS + Swift)     │
├─────────────────────────────────────┤
│    Configuration (~/.bowl/)         │
└─────────────────────────────────────┘
```

## Components

### 1. BowlApp.swift

- Main app entry point
- Handles app lifecycle
- Processes launch arguments (URLs from CLI)
- Sets up notifications

### 2. ContentView.swift

- Root SwiftUI view
- Manages overlay visibility
- Handles keyboard shortcuts (Cmd+B ...etc.)
- Coordinates between browser and overlay

### 3. BrowserView.swift

- Wraps WKWebView
- Handles navigation events
- Manages webview configuration
- Implements navigation delegate

### 4. BrowserState.swift

- Central state manager (ObservableObject)
- Tab management
- URL navigation logic
- Smart URL handling (auto-https, search detection)

### 5. OverlayView.swift

- Steam-inspired overlay UI
- Search/URL bar with fuzzy matching
- Tab list and management
- Action buttons (new tab, back, forward, reload)

### 6. Plugin System

#### PluginManager.swift

- Discovers and loads plugins from ~/.bowl/plugins
- Manages plugin lifecycle
- Injects plugin scripts into webview

#### PluginAPI.swift

- JavaScript ↔ Swift bridge
- Exposes Bowl API to plugins
- Handles plugin messages (navigation, storage, etc.)
- Security sandboxing

### 7. CLI (cli/main.swift)

- Terminal interface to Bowl
- Launches app or communicates with running instance
- URL argument passing
- Future: session management, scripting

## Data Flow

### Navigation Flow

```
User types URL in overlay
    ↓
BrowserState.navigate(to:)
    ↓
Smart URL handling (https://, search detection)
    ↓
WKWebView loads URL
    ↓
Update tab title, state
```

### Plugin Flow

```
Page loads
    ↓
PluginManager injects plugin scripts
    ↓
Plugin calls window.bowl.navigate()
    ↓
Message sent via WebKit bridge
    ↓
PluginAPI.handlePluginAction()
    ↓
BrowserState performs action
```

### CLI Flow

```
Terminal: bowl https://github.com
    ↓
Check if Bowl.app running
    ↓
If running: Send URL via notification
If not: Launch Bowl.app with URL argument
    ↓
Bowl.app receives URL and navigates
```

## Plugin Architecture

Plugins are JavaScript files with a manifest that run in the webview context:

```
~/.bowl/plugins/my-plugin/
├── manifest.json    (metadata, hooks, permissions)
└── plugin.js        (JavaScript code)
```

### Plugin Hooks

- `onPageLoad` - Execute when page loads
- `onKeyPress` - Capture keyboard events
- `onTabSwitch` - Execute on tab changes
- `onNavigate` - Before navigation occurs

### Plugin API (JavaScript)

```javascript
window.bowl = {
    navigate(url)       // Navigate current tab
    newTab(url)         // Open new tab
    closeTab(index)     // Close tab
    storage.get(key)    // Get stored data
    storage.set(k, v)   // Store data
    notify(message)     // Show notification
}
```

### Security Model

- Plugins run in webview sandbox
- No file system access
- No native code execution
- Storage scoped per-plugin
- Permissions declared in manifest

## Configuration

TOML-based config at `~/.bowl/config.toml`:

```toml
[general]
homepage = "about:blank"
search_engine = "duckduckgo"

[keybindings]
toggle_overlay = "Cmd+B"

[plugins]
enabled = ["vim-mode", "ad-blocker"]

[privacy]
do_not_track = true
block_third_party_cookies = true
```

Config is parsed at startup and can be hot-reloaded.

## Future Architecture

### Local LLM Integration

```
┌─────────────────────────────┐
│  Overlay UI                 │
│  ┌─────────────────────┐    │
│  │ Chat Interface      │    │
│  └─────────────────────┘    │
├─────────────────────────────┤
│  llama.cpp / MLX           │
│  (Local inference)          │
├─────────────────────────────┤
│  Context Manager            │
│  - Page content             │
│  - History                  │
│  - User preferences         │
└─────────────────────────────┘
```

### Multi-Process Model

For better stability and security:

- Main process (UI, plugins)
- Renderer processes (per-tab WKWebViews)
- Network process (caching, requests)

### Extension System

Beyond JavaScript plugins:

- Native Swift extensions
- Binary plugins (via dynamic loading)
- Python/Lua scripting (via bridge)

## Performance Targets

- **Launch time**: <200ms cold start
- **Memory**: <30MB idle, <100MB with 10 tabs
- **Bundle size**: <5MB (optimized)
- **Tab switching**: <16ms (60fps)

## Tech Stack

- **Language**: Swift 5.9+
- **UI**: SwiftUI (overlay), AppKit (window management)
- **Web Engine**: WKWebView (WebKit)
- **Build**: Xcode 15+, Swift Package Manager (CLI)
- **Target**: macOS 13.0+ (Ventura)

## Key Design Decisions

### Why WKWebView?

- Native to macOS (no bloat)
- Maintained by Apple
- Excellent performance
- Free security updates

### Why Swift?

- Native performance
- Modern language
- SwiftUI for rapid UI
- Strong typing and safety

### Why Plugin System?

- Keep core minimal
- User customization
- Community extensions
- Easy to maintain

### Why Overlay UI?

- Zero visual clutter
- Keyboard-first UX
- Customizable (plugins can extend)
- Familiar to Steam users

## Contributing

See `/docs/CONTRIBUTING.md` for development setup and guidelines.
