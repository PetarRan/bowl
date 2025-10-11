import Foundation
import AppKit

// Bowl CLI - launches the Bowl browser with optional URL

func main() {
    let arguments = CommandLine.arguments

    // Handle special case: "bowl ." opens git repo
    var urlToOpen: String? = nil
    if arguments.count > 1 && arguments[1] == "." {
        urlToOpen = getGitRepoURL()
        if urlToOpen == nil {
            print("Error: Not a git repository or no remote URL found")
            exit(1)
        }
    } else if arguments.count > 1 {
        urlToOpen = arguments[1]
    }

    // Check if Bowl.app is already running
    let runningApps = NSWorkspace.shared.runningApplications
    let bowlApp = runningApps.first { $0.bundleIdentifier == "com.bowl.browser" }

    if let app = bowlApp {
        // Bowl is already running, activate it
        app.activate()

        // If URL provided, send it to the running instance
        if let url = urlToOpen {
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

            if let url = urlToOpen {
                configuration.arguments = [url]
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

func getGitRepoURL() -> String? {
    // Get current directory
    let currentDir = FileManager.default.currentDirectoryPath

    // Check if .git exists
    let gitPath = "\(currentDir)/.git"
    guard FileManager.default.fileExists(atPath: gitPath) else {
        return nil
    }

    // Run git command to get remote URL
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["git", "config", "--get", "remote.origin.url"]
    task.currentDirectoryPath = currentDir

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = Pipe()

    do {
        try task.run()
        task.waitUntilExit()

        guard task.terminationStatus == 0 else {
            return nil
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }

        // Convert git URL to HTTPS URL for browser
        return convertGitURLToHTTPS(output)
    } catch {
        return nil
    }
}

func convertGitURLToHTTPS(_ gitURL: String) -> String {
    var url = gitURL

    // Handle SSH format: git@github.com:user/repo.git
    if url.hasPrefix("git@") {
        url = url.replacingOccurrences(of: "git@", with: "https://")
        url = url.replacingOccurrences(of: ".com:", with: ".com/")
        url = url.replacingOccurrences(of: ".org:", with: ".org/")
    }

    // Remove .git suffix
    if url.hasSuffix(".git") {
        url = String(url.dropLast(4))
    }

    return url
}

main()
