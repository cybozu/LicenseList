// swift-tools-version: 5.6

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
        .target(
            name: "LicenseList"),
        .testTarget(
            name: "LicenseListTests",
            dependencies: ["LicenseList"],
            resources: [
                .copy("license-list.plist")
            ])
    ]
)
