//
//  SourcePackagesParser.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

final class SourcePackagesParser {
    let projectRootPath: String
    let sourcePackagesPath: String

    init(_ projectRootPath: String, _ sourcePackagesPath: String) {
        self.projectRootPath = projectRootPath
        self.sourcePackagesPath = sourcePackagesPath
    }

    func run() throws {
        // Load workspace-state.json
        let workspaceStateURL = URL(fileURLWithPath: sourcePackagesPath)
            .appendingPathComponent("workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data)
        else {
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
            guard let license = extractLicense(directoryURL) else {
                return nil
            }
            return Library(name: dependency.packageRef.name,
                           licenseType: license.0,
                           licenseBody: license.1)

        }
        .sorted { $0.name.lowercased() < $1.name.lowercased() }

        if libraries.isEmpty {
            throw SPPError.noLibraries
        }
        printLibraries(libraries)

        // Export license-list.plist
        let saveURL = URL(fileURLWithPath: projectRootPath)
            .appendingPathComponent("license-list.plist")
        try exportLicenseList(libraries, to: saveURL)
    }

    private func extractLicense(_ directoryURL: URL) -> (LicenseType, String)? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.path)) ?? []
        let _licenseURL = contents.map { content in
            return directoryURL.appendingPathComponent(content)
        }.filter { contentURL in
            if contentURL.deletingPathExtension().lastPathComponent.lowercased() == "license" {
                var isDiractory: ObjCBool = false
                fm.fileExists(atPath: contentURL.path, isDirectory: &isDiractory)
                return isDiractory.boolValue == false
            }
            return false
        }.first

        if let licenseURL = _licenseURL,
           let text = try? String(contentsOf: licenseURL) {
            return (LicenseType(licenseText: text), text)
        }

        return nil
    }

    private func printLibraries(_ libraries: [Library]) {
        let length = libraries.map { $0.name.count }.max() ?? 0
        libraries.forEach { library in
            let name = library.name.padding(toLength: length, withPad: " ", startingAt: 0)
            print(name, library.licenseType.rawValue)
        }
    }

    private func exportLicenseList(_ libraries: [Library], to saveURL: URL) throws {
        let array: [[String: Any]] = libraries.map { library in
            return [
                "name": library.name,
                "licenseType": library.licenseType.rawValue,
                "licenseBody": library.licenseBody
            ]
        }
        let dict: [String: Any] = ["libraries": array]
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dict,
                                                          format: .xml,
                                                          options: .zero)
            try data.write(to: saveURL, options: .atomic)
        } catch {
            throw SPPError.couldNotExportLicenseList
        }
    }
}
