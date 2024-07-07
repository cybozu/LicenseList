// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LicenseList",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LicenseList",
            targets: ["LicenseList"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", exact: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "spp",
            path: "Sources/SourcePackagesParser"
        ),
        .plugin(
            name: "PrepareLicenseList",
            capability: .buildTool(),
            dependencies: [.target(name: "spp")]
        ),
        .testTarget(
            name: "SourcePackagesParserTests",
            dependencies: [
                .target(name: "spp", condition: .when(platforms: [.macOS]))
            ],
            resources: [
                .copy("Resources/CouldNotRead"),
                .copy("Resources/NoLibraries"),
                .copy("Resources/SourcePackages")
            ]
        ),
        .target(
            name: "LicenseList",
            plugins: ["PrepareLicenseList"]
        )
    ]
)
