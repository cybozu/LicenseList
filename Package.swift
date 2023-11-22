// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "LicenseList",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(
            name: "spp",
            targets: ["spp"]
        ),
        .plugin(
            name: "PrepareLicenseList",
            targets: ["PrepareLicenseList"]
        ),
        .library(
            name: "LicenseList",
            targets: ["LicenseList"]
        )
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
                .target(
                    name: "spp",
                    condition: .when(platforms: [.macOS])
                )
            ],
            resources: [
                .copy("Resources/CouldNotRead"),
                .copy("Resources/NoLibraries"),
                .copy("Resources/SourcePackages")
            ]
        ),

        .target(name: "LicenseList"),
        .testTarget(
            name: "LicenseListTests",
            dependencies: [
                .target(
                    name: "LicenseList",
                    condition: .when(platforms: [.iOS])
                )
            ],
            resources: [
                .copy("license-list.plist")
            ]
        )
    ]
)
