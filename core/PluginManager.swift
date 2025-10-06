import Foundation
import WebKit

/// Plugin Manager - loads and manages Bowl plugins
class PluginManager: ObservableObject {
    static let shared = PluginManager()

    @Published var loadedPlugins: [Plugin] = []

    private let pluginsDirectory: URL

    init() {
        // Plugins directory: ~/.bowl/plugins/
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        self.pluginsDirectory = homeDir.appendingPathComponent(".bowl/plugins")

        createPluginsDirectoryIfNeeded()
        loadPlugins()
    }

    private func createPluginsDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: pluginsDirectory.path) {
            try? FileManager.default.createDirectory(at: pluginsDirectory, withIntermediateDirectories: true)
        }
    }

    func loadPlugins() {
        guard let pluginDirs = try? FileManager.default.contentsOfDirectory(
            at: pluginsDirectory,
            includingPropertiesForKeys: nil
        ) else { return }

        loadedPlugins.removeAll()

        for pluginDir in pluginDirs where pluginDir.hasDirectoryPath {
            if let plugin = loadPlugin(from: pluginDir) {
                loadedPlugins.append(plugin)
                print("✓ Loaded plugin: \(plugin.manifest.name)")
            }
        }
    }

    private func loadPlugin(from directory: URL) -> Plugin? {
        let manifestPath = directory.appendingPathComponent("manifest.json")

        guard let manifestData = try? Data(contentsOf: manifestPath),
              let manifest = try? JSONDecoder().decode(PluginManifest.self, from: manifestData) else {
            return nil
        }

        // Load main script if present
        let scriptPath = directory.appendingPathComponent(manifest.main)
        let script = try? String(contentsOf: scriptPath, encoding: .utf8)

        return Plugin(manifest: manifest, script: script, directory: directory)
    }

    /// Inject all plugins into a webview
    func injectPlugins(into webView: WKWebView) {
        for plugin in loadedPlugins where plugin.script != nil {
            let userScript = WKUserScript(
                source: plugin.script!,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: false
            )
            webView.configuration.userContentController.addUserScript(userScript)
        }
    }

    /// Get plugins that hook into a specific event
    func getPluginsForHook(_ hookName: String) -> [Plugin] {
        return loadedPlugins.filter { plugin in
            plugin.manifest.hooks?.contains(hookName) ?? false
        }
    }
}

/// Plugin representation
struct Plugin: Identifiable {
    let id = UUID()
    let manifest: PluginManifest
    let script: String?
    let directory: URL
}

/// Plugin manifest structure
struct PluginManifest: Codable {
    let name: String
    let version: String
    let description: String
    let author: String?
    let main: String // main script file (e.g., "plugin.js")
    let hooks: [String]? // hook points this plugin uses
    let permissions: [String]? // requested permissions
}
