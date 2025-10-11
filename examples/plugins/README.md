<img src="../../docs/assets/bowl.png" alt="Bowl" width='200px'>

## Bowl Plugins

### Creating a Plugin

Bowl plugins extend the browser with custom functionality using JavaScript and the Bowl API.

### Plugin Structure

```
~/.bowl/plugins/my-plugin/
├── manifest.json
└── plugin.js
```

### manifest.json

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What your plugin does",
  "author": "Your Name",
  "main": "plugin.js",
  "hooks": ["onPageLoad", "onKeyPress"],
  "permissions": ["navigation", "dom", "storage"]
}
```

### plugin.js

```javascript
(function () {
  "use strict";

  console.log("My plugin loaded!");

  // Use Bowl API
  if (window.bowl) {
    // Navigate to a URL
    window.bowl.navigate("https://example.com");

    // Open new tab
    window.bowl.newTab("https://github.com");

    // Close current tab
    window.bowl.closeTab(0);

    // Storage
    window.bowl.storage.set("myKey", "myValue");
    window.bowl.storage.get("myKey");

    // Show notification
    window.bowl.notify("Hello from my plugin!");
  }

  // Your plugin logic here
  document.addEventListener("keydown", (e) => {
    if (e.key === "x") {
      console.log("X pressed!");
    }
  });
})();
```

## Available Hooks

- `onPageLoad` - Runs when a page loads
- `onKeyPress` - Captures keyboard events
- `onTabSwitch` - Runs when switching tabs
- `onNavigate` - Runs before navigation

## Bowl API Reference

### Navigation

- `bowl.navigate(url)` - Navigate to URL in current tab
- `bowl.newTab(url)` - Open new tab with optional URL
- `bowl.closeTab(index)` - Close tab by index

### Storage

- `bowl.storage.get(key)` - Get stored value
- `bowl.storage.set(key, value)` - Store value

### UI

- `bowl.notify(message)` - Show notification

### Events

Listen for Bowl events:

```javascript
window.addEventListener("bowl:storageResponse", (e) => {
  console.log("Storage value:", e.detail.value);
});
```

## Example Plugins

Check the `examples/plugins/` directory:

- **vim-mode** - Navigate with vim keybindings (j/k/h/l)
- **ad-blocker** - Remove common ad elements from pages

## Installing Plugins

1. Create plugin directory: `mkdir -p ~/.bowl/plugins/my-plugin`
2. Add `manifest.json` and `plugin.js`
3. Restart Bowl or reload plugins from overlay
4. Enable in config: `~/.bowl/config.toml`

## Plugin Development

Enable dev mode in config:

```toml
[developer]
plugin_dev_mode = true
```

This enables:

- Hot reload on file changes
- Console logging
- Error reporting in overlay

## Security

Plugins run in the webview context and have access to:

- DOM manipulation
- Network requests (via page context)
- Bowl API functions

Plugins **cannot**:

- Access file system directly
- Run native code
- Access other apps

Always review plugin source before installing!
