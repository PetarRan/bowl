import SwiftUI

@main
struct BowlApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Window") {
                    appDelegate.openNewWindow()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var additionalWindows: [NSWindow] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide menu bar for minimal look
        NSApp.setActivationPolicy(.regular)

        // Create default config if needed
        BowlConfig.createDefaultConfig()

        // Check if launched with URL argument
        if CommandLine.arguments.count > 1 {
            let url = CommandLine.arguments[1]
            NotificationCenter.default.post(name: .loadURL, object: url)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Only terminate after the last window closes
        return true
    }

    func openNewWindow() {
        let config = BowlConfig.load()
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: config.windowWidth, height: config.windowHeight),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        newWindow.titlebarAppearsTransparent = true
        newWindow.titleVisibility = .hidden

        // Create a window controller to properly manage the window lifecycle
        let windowController = NSWindowController(window: newWindow)

        newWindow.center()
        newWindow.contentView = NSHostingView(rootView: ContentView())

        // Store reference to prevent deallocation
        additionalWindows.append(newWindow)

        // Remove from array when window closes
        // Todo: Use weak reference to avoid retain cycle
        // Another Todo: Maybe use NSWindowDelegate instead of NotificationCenter
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: newWindow,
            queue: .main
        ) { [weak self] _ in
            self?.additionalWindows.removeAll { $0 === newWindow }
        }

        windowController.showWindow(nil)
    }
}

extension Notification.Name {
    static let loadURL = Notification.Name("loadURL")
}
