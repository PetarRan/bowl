import Foundation
import AppKit

// Bowl CLI - launches the Bowl browser with optional URL

func main() {
    let arguments = CommandLine.arguments

    // Check if Bowl.app is already running
    let runningApps = NSWorkspace.shared.runningApplications
    let bowlApp = runningApps.first { $0.bundleIdentifier == "com.bowl.browser" }

    if let app = bowlApp {
        // Bowl is already running, activate it
        app.activate(options: .activateIgnoringOtherApps)

        // If URL provided, send it to the running instance
        if arguments.count > 1 {
            let url = arguments[1]
            // Use distributed notifications to communicate with running app
            DistributedNotificationCenter.default().postNotificationName(
                NSNotification.Name("com.bowl.browser.openURL"),
                object: url,
                userInfo: nil,
                deliverImmediately: true
            )
        }
    } else {
        // Launch Bowl.app
        let bundlePath = getBowlAppPath()

        if let path = bundlePath {
            let configuration = NSWorkspace.OpenConfiguration()

            if arguments.count > 1 {
                configuration.arguments = [arguments[1]]
            }

            NSWorkspace.shared.openApplication(
                at: URL(fileURLWithPath: path),
                configuration: configuration
            ) { app, error in
                if let error = error {
                    print("Error launching Bowl: \(error.localizedDescription)")
                    exit(1)
                }
            }

            // Keep CLI alive briefly to ensure app launches
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
        } else {
            print("Error: Bowl.app not found. Please install Bowl first.")
            exit(1)
        }
    }
}

func getBowlAppPath() -> String? {
    // Check common locations
    let possiblePaths = [
        "/Applications/Bowl.app",
        "\(NSHomeDirectory())/Applications/Bowl.app",
        // For development
        "\(FileManager.default.currentDirectoryPath)/build/Bowl.app"
    ]

    for path in possiblePaths {
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
    }

    return nil
}

main()
