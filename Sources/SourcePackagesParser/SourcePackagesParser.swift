//
//  SourcePackagesParser.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

final class SourcePackagesParser {
    let outputPath: String
    let sourcePackagesPath: String

    init(_ outputPath: String, _ sourcePackagesPath: String) {
        self.outputPath = outputPath
        self.sourcePackagesPath = sourcePackagesPath
    }

    func run() throws {
        // Load workspace-state.json
        let workspaceStateURL = URL(fileURLWithPath: sourcePackagesPath)
            .appendingPathComponent("workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            throw SPPError.couldNotReadFile(workspaceStateURL.lastPathComponent)
        }

        // Extract Libraries
        let checkoutsPath = "\(sourcePackagesPath)/checkouts"
        let libraries: [Library] = workspaceState.object.dependencies.compactMap { dependency in
            let repositoryName = dependency.packageRef.location
                .components(separatedBy: "/").last!
                .replacingOccurrences(of: ".git", with: "")
            let directoryURL = URL(fileURLWithPath: checkoutsPath)
                .appendingPathComponent(repositoryName)
            guard let licenseBody = extractLicenseBody(directoryURL) else {
                return nil
            }
            return Library(
                name: repositoryName,
                url: dependency.packageRef.location,
                licenseBody: licenseBody
            )
        }
        .sorted { $0.name.lowercased() < $1.name.lowercased() }

        if libraries.isEmpty {
            throw SPPError.noLibraries
        }
        printLibraries(libraries)

        // Export license-list.plist
        let saveURL = URL(fileURLWithPath: outputPath)
            .appendingPathComponent("license-list.plist")
        try exportLicenseList(libraries, to: saveURL)
    }

    private func extractLicenseBody(_ directoryURL: URL) -> String? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.path)) ?? []
        let _licenseURL = contents.map { content in
            return directoryURL.appendingPathComponent(content)
        }.filter { contentURL in
            let fileName = contentURL.deletingPathExtension().lastPathComponent.lowercased()
            if ["license", "licence"].contains(fileName) {
                var isDiractory: ObjCBool = false
                fm.fileExists(atPath: contentURL.path, isDirectory: &isDiractory)
                return isDiractory.boolValue == false
            }
            return false
        }.first
        guard let licenseURL = _licenseURL,
              let text = try? String(contentsOf: licenseURL) else {
            return nil
        }
        return text
    }

    private func printLibraries(_ libraries: [Library]) {
        let length = libraries.map { $0.name.count }.max() ?? 0
        libraries.forEach { library in
            let name = library.name.padding(toLength: length, withPad: " ", startingAt: 0)
            print(name)
        }
    }

    private func exportLicenseList(_ libraries: [Library], to saveURL: URL) throws {
        let array: [[String: Any]] = libraries.map { library in
            return [
                "name": library.name,
                "url": library.url,
                "licenseBody": library.licenseBody
            ]
        }
        if FileManager.default.fileExists(atPath: saveURL.path) {
            try FileManager.default.removeItem(at: saveURL)
        }
        let dict: [String: Any] = ["libraries": array]
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dict,
                                                          format: .xml,
                                                          options: .zero)
            try data.write(to: saveURL)
        } catch {
            throw SPPError.couldNotExportLicenseList
        }
    }
}
