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
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "SourcePackages not found"
    }

    func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
        var tmpPath = pluginWorkDirectory
        guard pluginWorkDirectory.string.contains("SourcePackages") else {
            throw SourcePackagesNotFoundError()
        }
        while tmpPath.lastComponent != "SourcePackages" {
            tmpPath = tmpPath.removingLastComponent()
        }
        return tmpPath
    }

    func makeBuildCommand(executablePath: Path, sourcePackagesPath: Path, outputPath: Path) -> Command {
        return .buildCommand(
            displayName: "Prepare LicenseList",
            executable: executablePath,
            arguments: [
                outputPath.string,
                sourcePackagesPath.string
            ],
            outputFiles: [
                outputPath.appending(["LicenseList.swift"])
            ]
        )
    }

    // This command works with the plugin specified in `Package.swift`.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            makeBuildCommand(
                executablePath: try context.tool(named: "spp").path,
                sourcePackagesPath: try sourcePackages(context.pluginWorkDirectory),
                outputPath: context.pluginWorkDirectory
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension PrepareLicenseList: XcodeBuildToolPlugin {
    // This command works with `Run Build Tool Plug-ins` in Xcode `Build Phase`.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return [
            makeBuildCommand(
                executablePath: try context.tool(named: "spp").path,
                sourcePackagesPath: try sourcePackages(context.pluginWorkDirectory),
                outputPath: context.pluginWorkDirectory
            )
        ]
    }
}

#endif
