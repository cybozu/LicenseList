import Foundation
import PackagePlugin

@main
struct PrepareLicenseList: BuildToolPlugin {
    struct DerivedDataNotFoundError: Error & CustomStringConvertible {
        let description: String = "DerivedData not found"
    }

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        guard pluginWorkDirectory.pathComponents.contains("DerivedData") else {
            throw DerivedDataNotFoundError()
        }

        var tmpURL = pluginWorkDirectory
        while tmpURL.deletingLastPathComponent().lastPathComponent != "DerivedData" {
            tmpURL.deleteLastPathComponent()
        }
        tmpURL.append(path: "SourcePackages")
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
