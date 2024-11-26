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
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        // Workaround for Mac Catalyst
        let debugMacCatalystPath = sourcePackagesPath.removingLastComponent()
            .appending(["Build", "Products", "Debug-maccatalyst"])
        let executablePath: Path = if FileManager.default.fileExists(atPath: debugMacCatalystPath.string) {
            debugMacCatalystPath.appending(["spp"])
        } else {
            try context.tool(named: "spp").path
        }
        return [
            makeBuildCommand(
                executablePath: executablePath,
                sourcePackagesPath: sourcePackagesPath,
                outputPath: context.pluginWorkDirectory
            )
        ]
    }
}
