import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var browserState = BrowserState()
    @State private var showOverlay = false

    var body: some View {
        ZStack {
            // The browser view - completely chrome-less
            BrowserView(state: browserState)
                .ignoresSafeArea()

            // Steam-inspired overlay
            if showOverlay {
                OverlayView(browserState: browserState, isVisible: $showOverlay)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            setupKeyboardShortcuts()
            setupNotifications()
        }
    }

    private func setupKeyboardShortcuts() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Cmd+B toggles overlay
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "b" {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showOverlay.toggle()
                }
                return nil
            }
            return event
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .loadURL,
            object: nil,
            queue: .main
        ) { notification in
            if let urlString = notification.object as? String {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.browserState.navigate(to: urlString)
                }
            }
        }

        // Load initial URL if passed via command line
        if CommandLine.arguments.count > 1 {
            let url = CommandLine.arguments[1]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.browserState.navigate(to: url)
            }
        }
    }
}
