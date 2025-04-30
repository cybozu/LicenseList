import Foundation

final class SourcePackagesParser {
    let outputURL: URL
    let sourcePackagesURL: URL

    init(_ outputPath: String, _ sourcePackagesPath: String) {
        outputURL = URL(filePath: outputPath)
        sourcePackagesURL = URL(filePath: sourcePackagesPath)
    }

    func run() throws {
        // Load workspace-state.json
        let workspaceStateURL = sourcePackagesURL.appending(path: "workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            throw SPPError.couldNotReadFile(workspaceStateURL.lastPathComponent)
        }

        // Extract Libraries
        let checkoutsURL = sourcePackagesURL.appending(path: "checkouts")
        let libraries: [Library] = workspaceState.object.dependencies.compactMap { dependency in
            let repositoryName = dependency.packageRef.location
                .components(separatedBy: "/").last!
                .replacingOccurrences(of: ".git", with: "")
            let directoryURL = checkoutsURL.appending(path: repositoryName)
            guard let licenseBody = extractLicenseBody(directoryURL) else {
                return nil
            }
            return Library(
                name: dependency.packageRef.name,
                url: dependency.packageRef.location,
                licenseBody: licenseBody
            )
        }
        .sorted { $0.name.lowercased() < $1.name.lowercased() }

        // Export LicenseList.swift
        try exportLicenseList(libraries)
    }

    private func extractLicenseBody(_ directoryURL: URL) -> String? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.path())) ?? []
        let licenseURL = contents
            .map { directoryURL.appending(path: $0) }
            .filter { contentURL in
                let fileName = contentURL.deletingPathExtension().lastPathComponent.lowercased()
                guard ["license", "licence"].contains(fileName) else {
                    return false
                }
                var isDirectory: ObjCBool = false
                fm.fileExists(atPath: contentURL.path(), isDirectory: &isDirectory)
                return isDirectory.boolValue == false
            }
            .first
        guard let licenseURL, let text = try? String(contentsOf: licenseURL) else {
            return nil
        }
        return text
    }

    private func printLibraries(_ libraries: [Library]) {
        let length = libraries.map(\.name.count).max() ?? .zero
        libraries.forEach { library in
            print(library.name.padding(toLength: length, withPad: " ", startingAt: .zero))
        }
    }

    private func makeCases(_ libraries: [Library]) -> String {
        let digits = Int(log10(Double(libraries.count))) + 1
        return libraries.indices
            .map { String(format: "case library%0\(digits)d", $0 + 1) }
            .joined(separator: "\n")
    }

    private func makeComputedProperty(
        _ libraries: [Library],
        variableName: String,
        keyPath: KeyPath<Library, String>
    ) -> String {
        let digits = Int(log10(Double(libraries.count))) + 1
        let cases = libraries.enumerated()
            .map {
                String(
                    format: "case .library%0\(digits)d: %@",
                    $0.offset + 1,
                    $0.element[keyPath: keyPath].debugDescription
                )
            }
            .joined(separator: "\n")
        let switchSelf = "switch self {\n\(cases)\n}".nest()
        return "var \(variableName): String {\n\(switchSelf)\n}"
    }

    private func exportLicenseList(_ libraries: [Library]) throws {
        var text = ""

        if libraries.isEmpty {
            print("Warning: No libraries.")
        } else {
            printLibraries(libraries)
            text = [
                makeCases(libraries),
                makeComputedProperty(libraries, variableName: "name", keyPath: \.name),
                makeComputedProperty(libraries, variableName: "url", keyPath: \.url),
                makeComputedProperty(libraries, variableName: "licenseBody", keyPath: \.licenseBody),
            ].joined(separator: "\n\n")
        }
        text = "enum SPPLibrary: CaseIterable {\n\(text.nest())\n}\n"

        if FileManager.default.fileExists(atPath: outputURL.path()) {
            try FileManager.default.removeItem(at: outputURL)
        }

        do {
            try text.data(using: .utf8)?.write(to: outputURL)
        } catch {
            throw SPPError.couldNotExportLicenseList
        }
    }
}
