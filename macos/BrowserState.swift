import SwiftUI
import WebKit

class BrowserState: ObservableObject {
    @Published var currentURL: String = "about:blank"
    @Published var tabs: [Tab] = []
    @Published var activeTabIndex: Int = 0

    weak var webView: WKWebView?

    init() {
        // Start with one blank tab
        tabs.append(Tab(url: "about:blank", title: "New Tab"))

        // Load initial URL if provided via command line
        if CommandLine.arguments.count > 1 {
            let url = CommandLine.arguments[1]
            currentURL = url
        }
    }

    func navigate(to urlString: String) {
        var finalURL = urlString

        // Smart URL handling
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            if urlString.contains(".") {
                finalURL = "https://\(urlString)"
            } else {
                // Treat as search query (use DuckDuckGo by default)
                finalURL = "https://duckduckgo.com/?q=\(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString)"
            }
        }

        if let url = URL(string: finalURL) {
            currentURL = finalURL
            webView?.load(URLRequest(url: url))

            // Update current tab
            if activeTabIndex < tabs.count {
                tabs[activeTabIndex].url = finalURL
            }
        }
    }

    func createTab(with urlString: String = "about:blank") {
        let newTab = Tab(url: urlString, title: "New Tab")
        tabs.append(newTab)
        activeTabIndex = tabs.count - 1
        navigate(to: urlString)
    }

    func closeTab(at index: Int) {
        guard tabs.count > 1, index < tabs.count else { return }
        tabs.remove(at: index)
        if activeTabIndex >= tabs.count {
            activeTabIndex = tabs.count - 1
        }
        if activeTabIndex >= 0 && activeTabIndex < tabs.count {
            navigate(to: tabs[activeTabIndex].url)
        }
    }

    func switchTab(to index: Int) {
        guard index < tabs.count else { return }
        activeTabIndex = index
        navigate(to: tabs[index].url)
    }
}

struct Tab: Identifiable {
    let id = UUID()
    var url: String
    var title: String
}
