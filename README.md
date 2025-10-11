# <img src="docs/assets/bowl.png" alt="Bowl" width='200px'>

A minimal, hackable browser for developers. Zero UI by default. Everything through an overlay. Built for speed and customization.

> **philosophy**

- light as air (<5MB, <30MB RAM)
- hackable and open source (MIT)
- overlay-driven (Steam-inspired, Cmd+B to access everything)
- terminal-friendly (`bowl <url>`)
- plugin-powered (vim mode, ad blocker, or build your own)
- cross-platform (macOS first, Linux coming)

## quick start

```bash
cd macos
./build.sh && ./install.sh

# Launch
bowl                    # Opens with overlay
bowl https://github.com # Opens URL directly
bowl "search query"     # Search DuckDuckGo
bowl .                  # Opens current git repo
```

**Keyboard shortcuts:**
- `Cmd+B` - Toggle overlay
- `Cmd+T` - New tab
- `Cmd+N` - New window

## features

- **Zero chrome** - Just a webview. No toolbars, no clutter.
- **Bowl overlay** - All controls in one place (Cmd+B) accessible all the time
- **CLI launcher** - `bowl <url>` from terminal
- **Plugin system** - JavaScript plugins with API access
- **Privacy-first** - No telemetry, local-first
- **Fast** - <200ms startup, minimal memory

## plugins

Built-in examples:

- **vim-mode** - Navigate with j/k/h/l
- **ad-blocker** - Remove ads automatically

Create your own:

```javascript
// ~/.bowl/plugins/my-plugin/plugin.js
window.bowl.notify("Hello from my plugin!");
```

See `examples/plugins/README.md` for API docs.

## documentation

- [Quick Start](docs/QUICKSTART.md) - Get up and running
- [Build Instructions](macos/BUILD.md) - Compile from source
- [Architecture](docs/ARCHITECTURE.md) - How Bowl works
- [Plugin Guide](examples/plugins/README.md) - Create plugins

## why bowl?

**For the ones who want:**

- A browser that gets out of the way
- Full control via plugins and config
- Terminal integration
- No bloat, no tracking
- Source code they can understand and modify

**Coming soon:**

- Local LLM integration (chat with pages, summarize, explain code)
- Linux support
- Session management
- More plugins

## license

MIT — Bowl is meant to be shared, hacked, and reshaped.

## contributing

Bowl is in early development. Want to help?

- Try it and report bugs
- Build plugins
- Submit PRs

Let's build a browser that respects developers. 🍜
