import Foundation
import PackagePlugin

@main
struct PrepareLicenseList: BuildToolPlugin {
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "SourcePackages not found"
    }

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        var tmpURL = pluginWorkDirectory
        guard pluginWorkDirectory.absoluteURL.path().contains("SourcePackages") else {
            throw SourcePackagesNotFoundError()
        }
        while tmpURL.lastPathComponent != "SourcePackages" {
            tmpURL = tmpURL.deletingLastPathComponent()
        }
        return tmpURL
    }

    func makeBuildCommand(executableURL: URL, sourcePackagesURL: URL, outputURL: URL) -> Command {
        .buildCommand(
            displayName: "Prepare LicenseList",
            executable: executableURL,
            arguments: [
                outputURL.absoluteURL.path(),
                sourcePackagesURL.absoluteURL.path(),
            ],
            outputFiles: [
                outputURL
            ]
        )
    }

    // This command works with the plugin specified in `Package.swift`.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            makeBuildCommand(
                executableURL: try context.tool(named: "spp").url,
                sourcePackagesURL: try sourcePackages(context.pluginWorkDirectoryURL),
                outputURL: context.pluginWorkDirectoryURL.appending(path: "LicenseList.swift")
            )
        ]
    }
}
