//
//  main.swift
//  
//
//  Created by ky0me22 on 2022/09/29.
//

import Foundation
import PackagePlugin

@main
struct PrepareLicenseList: BuildToolPlugin {
    var sourcePackagesNotFoundError: Error {
        return NSError(
            domain: "com.cybozu.PrepareLicenseList",
            code: 1,
            userInfo: ["message": "SourcePackages not found"]
        )
    }

    func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
        var tmpPath = pluginWorkDirectory
        guard pluginWorkDirectory.string.contains("SourcePackages") else {
            throw sourcePackagesNotFoundError
        }
        while tmpPath.lastComponent != "SourcePackages" {
            tmpPath = tmpPath.removingLastComponent()
        }
        return tmpPath
    }

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executablePath = try context.tool(named: "spp").path
        Swift.print("🐷", context.pluginWorkDirectory.string)
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let outputPath = context.pluginWorkDirectory.appending(["Resources"])

        return [
            .buildCommand(
                displayName: "Prepare LicenseList",
                executable: executablePath,
                arguments: [
                    outputPath.string,
                    sourcePackagesPath.string
                ],
                outputFiles: [
                    outputPath.appending(["license-list.plist"])
                ]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension PrepareLicenseList: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodeProjectPlugin.XcodePluginContext,
        target: XcodeProjectPlugin.XcodeTarget
    ) throws -> [PackagePlugin.Command] {
        let executablePath = try context.tool(named: "spp").path
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let outputPath = context.pluginWorkDirectory.appending(["Resources"])

        return [
            .buildCommand(
                displayName: "Prepare LicenseList",
                executable: executablePath,
                arguments: [
                    outputPath.string,
                    sourcePackagesPath.string
                ],
                outputFiles: [
                    outputPath.appending(["license-list.plist"]),
                ]
            ),
        ]
    }
}

#endif
