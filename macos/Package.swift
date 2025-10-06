// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Bowl",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "bowl-cli", targets: ["BowlCLI"])
    ],
    targets: [
        .executableTarget(
            name: "BowlCLI",
            path: "cli"
        )
    ]
)
