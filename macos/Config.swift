import Foundation

struct BowlConfig {
    var searchEngine: String
    var homepage: String
    var windowWidth: Int
    var windowHeight: Int

    static let `default` = BowlConfig(
        searchEngine: "https://duckduckgo.com/?q=",
        homepage: "about:blank",
        windowWidth: 1200,
        windowHeight: 800
    )

    static func load() -> BowlConfig {
        let configPath = "\(NSHomeDirectory())/.bowl/config.toml"
        guard FileManager.default.fileExists(atPath: configPath),
              let contents = try? String(contentsOfFile: configPath) else {
            return .default
        }

        return parse(contents)
    }

    static func createDefaultConfig() {
        let configPath = "\(NSHomeDirectory())/.bowl/config.toml"
        let configDir = "\(NSHomeDirectory())/.bowl"

        // Create .bowl directory if needed
        try? FileManager.default.createDirectory(atPath: configDir, withIntermediateDirectories: true)

        // Don't overwrite existing config
        guard !FileManager.default.fileExists(atPath: configPath) else { return }

        let defaultConfig = """
        # Bowl Browser Configuration

        [browser]
        search_engine = "https://duckduckgo.com/?q="
        homepage = "about:blank"

        [window]
        width = 1200
        height = 800

        [plugins]
        # enabled = ["vim-mode", "ad-blocker"]
        """

        try? defaultConfig.write(toFile: configPath, atomically: true, encoding: .utf8)
    }

    private static func parse(_ toml: String) -> BowlConfig {
        var config = BowlConfig.default

        let lines = toml.components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty, !trimmed.hasPrefix("#") else { continue }

            let parts = trimmed.components(separatedBy: "=").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else { continue }

            let key = parts[0]
            let value = parts[1].replacingOccurrences(of: "\"", with: "")

            switch key {
            case "search_engine":
                config.searchEngine = value
            case "homepage":
                config.homepage = value
            case "width":
                if let width = Int(value) {
                    config.windowWidth = width
                }
            case "height":
                if let height = Int(value) {
                    config.windowHeight = height
                }
            default:
                break
            }
        }

        return config
    }
}
