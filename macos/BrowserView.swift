import SwiftUI
import WebKit

struct BrowserView: NSViewRepresentable {
    @ObservedObject var state: BrowserState

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()

        // Enable developer extras
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        // Store reference in state
        state.webView = webView

        // Load initial URL if provided
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.state.currentURL != "about:blank" {
                self.state.navigate(to: self.state.currentURL)
            }
        }

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Updates handled via state
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(state: state)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var state: BrowserState

        init(state: BrowserState) {
            self.state = state
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                state.currentURL = url
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.title") { result, error in
                if let title = result as? String, !title.isEmpty {
                    DispatchQueue.main.async {
                        if self.state.activeTabIndex < self.state.tabs.count {
                            self.state.tabs[self.state.activeTabIndex].title = title
                        }
                    }
                }
            }
        }

        // Handle new window requests
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                state.createTab(with: url.absoluteString)
            }
            return nil
        }
    }
}
