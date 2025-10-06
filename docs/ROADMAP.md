<img src="../docs/assets/bowl.png" alt="Bowl" width='200px'>

## Bowl Browser Roadmap

### Version 0.1.0 - MVP (Current)

**Goal**: Functional minimal browser with plugin system

- [x] Basic WKWebView shell (zero chrome)
- [x] Overlay UI with Cmd+B toggle
- [x] Tab management
- [x] CLI launcher (`bowl <url>`)
- [x] Plugin architecture (JS injection)
- [x] Bowl Plugin API (navigate, tabs, storage)
- [x] Example plugins
- [ ] Dynamic islands overlay system
- [ ] Build system and install script
- [ ] Intro / Onboarding
- [ ] Basic configuration (TOML)
- [ ] Documentation

**Target**: January 2025

### Version 0.2.0 - Polish & Performance

**Goal**: Production-ready for early adopters

- [ ] Config hot-reload
- [ ] Plugin hot-reload (dev mode)
- [ ] History and bookmarks
- [ ] Downloads manager
- [ ] Keyboard shortcut customization
- [ ] Performance optimization (<200ms launch)
- [ ] Memory optimization (<30MB idle)
- [ ] Tab hibernation (unload inactive tabs)
- [ ] Session management (save/restore)
- [ ] Shell completions (zsh/bash/fish)

**Target**: February 2025

### Version 0.3.0 - Developer Tools

**Goal**: Make it the best browser for developers

- [ ] Enhanced DevTools integration
- [ ] Network inspector overlay
- [ ] Cookie/localStorage editor
- [ ] HTTP header viewer
- [ ] Localhost auto-detection
- [ ] User agent switcher
- [ ] Responsive design mode
- [ ] Screenshot tool
- [ ] Performance metrics dashboard

**Target**: March 2025

### Version 0.4.0 - Extensibility

**Goal**: Rich plugin ecosystem

- [ ] Native Swift plugin API (beyond JS)
- [ ] Plugin marketplace (curated git repo)
- [ ] Plugin auto-update
- [ ] Plugin sandboxing improvements
- [ ] More plugin hooks
- [ ] Plugin settings UI
- [ ] Community plugin templates

**Plugins to build**:

- Dark mode enforcer
- Custom search engines
- Keyboard maestro integration
- Clipboard manager
- Tab groups
- Reading mode
- Password manager integration

**Target**: April 2025

### Version 0.5.0 - Linux Support

**Goal**: Cross-platform (Linux)

- [ ] Linux port (WebKitGTK)
- [ ] GTK-based overlay UI
- [ ] Wayland support
- [ ] X11 support
- [ ] Package for major distros (deb, rpm, AUR)
- [ ] Unified config across platforms

**Target**: May 2025

### Version 1.0.0 - Production Ready

**Goal**: Stable, polished, ready for daily use

- [ ] Comprehensive test suite
- [ ] Crash reporting (opt-in, local)
- [ ] Accessibility support
- [ ] Localization (i18n)
- [ ] Comprehensive documentation
- [ ] Video tutorials
- [ ] Migration tools (from Chrome/Firefox)
- [ ] Auto-updater
- [ ] Homebrew formula
- [ ] Code signing for macOS

**Target**: June 2025

### Version 2.0.0 - Local LLM Integration

**Goal**: AI-powered browser, privacy-first

#### Core Features

- [ ] Embed llama.cpp for local inference
- [ ] Chat overlay (Cmd+L or similar)
- [ ] Page summarization
- [ ] Code explanation
- [ ] Smart search (semantic)
- [ ] Auto-fill assistance
- [ ] Reading assistant

#### Context Management

- [ ] Page content extraction
- [ ] History awareness
- [ ] User preferences learning
- [ ] Privacy controls (what LLM can see)

#### Model Support

- [ ] Support multiple model formats (GGUF, MLX)
- [ ] Model download manager
- [ ] Model switching
- [ ] Quantization options

#### Privacy Guarantees

- [ ] 100% local inference
- [ ] No data sent to cloud
- [ ] Encrypted model cache
- [ ] Per-site LLM permissions

**Target**: Q3 2025

### Future Ideas (2.x+)

#### Advanced Features

- [ ] Vertical tabs option
- [ ] Tab stacking/grouping
- [ ] Workspace management
- [ ] Sync via Git (config, bookmarks)
- [ ] Container tabs (like Firefox)
- [ ] Custom CSS injection
- [ ] Userscripts support (Greasemonkey-style)

#### AI Features (Beyond 2.0)

- [ ] Smart autocomplete in forms
- [ ] Automatic translation
- [ ] Content recommendation
- [ ] Accessibility improvements (AI-powered)
- [ ] Voice control
- [ ] Visual search

#### Developer Features

- [ ] GraphQL inspector
- [ ] WebSocket debugger
- [ ] Service worker inspector
- [ ] Progressive Web App tools
- [ ] Performance profiling

#### Platform Expansion

- [ ] Windows support
- [ ] iOS/iPadOS version (mobile)
- [ ] Sync between devices

### Community

- [ ] Plugin contest
- [ ] Official plugins
- [ ] Community forums
- [ ] Newsletter

### Non-Goals

Things Bowl will **NOT** do:

- ❌ Telemetry or tracking
- ❌ Bundled services or accounts
- ❌ Tell you what to do, the world is your oyster, or should I say, bowl.

## Contributing

Want to help? Check out:

- Open issues on GitHub
- `/docs/CONTRIBUTING.md`
- Plugin ideas in `/examples/plugins/`

## Feedback

Share your thoughts:

- GitHub Discussions
- Issues for bugs/features
- Show HN post (when ready)
