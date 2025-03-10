import Foundation
import PackagePlugin

@main
struct PrepareLicenseList: BuildToolPlugin {
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "SourcePackages not found"
    }

    func checkConditions(of url: URL) throws -> Bool {
        guard url.isFileURL, url.pathComponents.count > 1 else {
            throw SourcePackagesNotFoundError()
        }
        do {
            let isDirectory = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory!
            let containsSourcePackages = try FileManager.default
                .contentsOfDirectory(atPath: url.absoluteURL.path())
                .contains("SourcePackages")
            return isDirectory && containsSourcePackages
        } catch {
            throw SourcePackagesNotFoundError()
        }
    }

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        var tmpURL = pluginWorkDirectory.absoluteURL

        while try !checkConditions(of: tmpURL) {
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
