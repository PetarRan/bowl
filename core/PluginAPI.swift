import Foundation
import WebKit

/// JavaScript Bridge for Plugin API
class PluginAPI: NSObject, WKScriptMessageHandler {
    weak var browserState: BrowserState?

    init(browserState: BrowserState) {
        self.browserState = browserState
    }

    /// Handle messages from JavaScript plugins
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String else {
            return
        }

        handlePluginAction(action: action, payload: body["payload"])
    }

    private func handlePluginAction(action: String, payload: Any?) {
        switch action {
        case "navigate":
            if let url = payload as? String {
                browserState?.navigate(to: url)
            }

        case "newTab":
            if let url = payload as? String {
                browserState?.createTab(with: url)
            } else {
                browserState?.createTab()
            }

        case "closeTab":
            if let index = payload as? Int {
                browserState?.closeTab(at: index)
            }

        case "getStorage":
            if let key = payload as? String {
                let value = UserDefaults.standard.string(forKey: "plugin_\(key)")
                // Send response back to plugin
                notifyPlugin(event: "storageResponse", data: ["key": key, "value": value ?? ""])
            }

        case "setStorage":
            if let data = payload as? [String: String],
               let key = data["key"],
               let value = data["value"] {
                UserDefaults.standard.set(value, forKey: "plugin_\(key)")
            }

        case "showNotification":
            if let message = payload as? String {
                showNotification(message: message)
            }

        default:
            print("Unknown plugin action: \(action)")
        }
    }

    private func notifyPlugin(event: String, data: [String: Any]) {
        guard let webView = browserState?.webView else { return }

        if let jsonData = try? JSONSerialization.data(withJSONObject: data),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let js = "window.dispatchEvent(new CustomEvent('bowl:\(event)', { detail: \(jsonString) }))"
            webView.evaluateJavaScript(js)
        }
    }

    private func showNotification(message: String) {
        // Simple notification - can be enhanced later
        DispatchQueue.main.async {
            // This would show a native notification or in-app toast
            print("Plugin notification: \(message)")
        }
    }

    /// Setup the plugin API in a webview
    static func setup(in webView: WKWebView, browserState: BrowserState) -> PluginAPI {
        let api = PluginAPI(browserState: browserState)

        // Add message handler
        webView.configuration.userContentController.add(api, name: "bowlPlugin")

        // Inject Bowl API into pages
        let apiScript = """
        window.bowl = {
            navigate: function(url) {
                window.webkit.messageHandlers.bowlPlugin.postMessage({
                    action: 'navigate',
                    payload: url
                });
            },
            newTab: function(url) {
                window.webkit.messageHandlers.bowlPlugin.postMessage({
                    action: 'newTab',
                    payload: url
                });
            },
            closeTab: function(index) {
                window.webkit.messageHandlers.bowlPlugin.postMessage({
                    action: 'closeTab',
                    payload: index
                });
            },
            storage: {
                get: function(key) {
                    window.webkit.messageHandlers.bowlPlugin.postMessage({
                        action: 'getStorage',
                        payload: key
                    });
                },
                set: function(key, value) {
                    window.webkit.messageHandlers.bowlPlugin.postMessage({
                        action: 'setStorage',
                        payload: { key: key, value: value }
                    });
                }
            },
            notify: function(message) {
                window.webkit.messageHandlers.bowlPlugin.postMessage({
                    action: 'showNotification',
                    payload: message
                });
            }
        };
        """

        let userScript = WKUserScript(
            source: apiScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )

        webView.configuration.userContentController.addUserScript(userScript)

        return api
    }
}
