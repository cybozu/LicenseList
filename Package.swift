// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "LicenseList",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(
            name: "spp",
            targets: ["SourcePackagesParser"]),
        .library(
            name: "LicenseList",
            targets: ["LicenseList"])
    ],
    targets: [
        .executableTarget(
            name: "SourcePackagesParser"),
        .testTarget(
            name: "SourcePackagesParserTests",
            dependencies: [
                .target(name: "SourcePackagesParser",
                        condition: .when(platforms: [.macOS]))
            ],
            resources: [
                .copy("Resources/CouldNotRead"),
                .copy("Resources/NoLibraries"),
                .copy("Resources/SourcePackages")
            ]),
        .target(
            name: "LicenseList"),
        .testTarget(
            name: "LicenseListTests",
            dependencies: [
                .target(name: "LicenseList",
                        condition: .when(platforms: [.iOS]))
            ],
            resources: [
                .copy("license-list.plist")
            ])
    ]
)
