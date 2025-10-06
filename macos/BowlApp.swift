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
            CommandGroup(replacing: .newItem) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide menu bar for minimal look
        NSApp.setActivationPolicy(.regular)

        // Check if launched with URL argument
        if CommandLine.arguments.count > 1 {
            let url = CommandLine.arguments[1]
            NotificationCenter.default.post(name: .loadURL, object: url)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

extension Notification.Name {
    static let loadURL = Notification.Name("loadURL")
    static let toggleOverlay = Notification.Name("toggleOverlay")
}
