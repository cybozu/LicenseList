import XCTest

#if os(macOS)
final class SourcePackagesParserTests: XCTestCase {
    struct Library: Equatable {
        var name: String
        var type: String
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }

    func directoryURL(_ key: String) -> URL? {
        return Bundle.module.resourceURL?.appendingPathComponent(key)
    }

    func test_invalid_args() throws {
        let sppBinary = productsDirectory.appendingPathComponent("spp")
        let process = Process()
        process.executableURL = sppBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 1)
        let expect = "USAGE: swift run spp [output directory path] [SourcePackages directory path]\n"
        XCTAssertEqual(actual, expect)
    }

    func test_CouldNotRead_workspace_state_json() throws {
        let couldNotReadURL = try XCTUnwrap(directoryURL("CouldNotRead"))

        let sppBinary = productsDirectory.appendingPathComponent("spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [couldNotReadURL.path, couldNotReadURL.path]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 1)
        let expect = "Error: Could not read workspace-state.json.\n"
        XCTAssertEqual(actual, expect)
    }

    func test_NoLibraries() throws {
        let noLibrariesURL = try XCTUnwrap(directoryURL("NoLibraries"))

        let sppBinary = productsDirectory.appendingPathComponent("spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [noLibrariesURL.path, noLibrariesURL.path]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 0)
        let expect = "Error: No libraries.\n"
        XCTAssertEqual(actual, expect)
    }

    func xtest_CouldNotExportLicenseList() throws {
        // It is not possible to intentionally reproduce this error.
    }

    func test_SourcePackagesParser_run() throws {
        let sourcePackagesURL = try XCTUnwrap(directoryURL("SourcePackages"))

        let sppBinary = productsDirectory.appendingPathComponent("spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [sourcePackagesURL.path, sourcePackagesURL.path]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 0)
        let expect = """
        Package-A Unknown License
        Package-B Apache license 2.0
        Package-C MIT License
        Package-D BSD 3-clause Clear license
        Package-E zLib License

        """
        XCTAssertEqual(actual, expect)

        let licenseListURL = sourcePackagesURL.appendingPathComponent("license-list.plist")
        let plistData = try XCTUnwrap(Data(contentsOf: licenseListURL))
        let plist = try XCTUnwrap(PropertyListSerialization.propertyList(from: plistData, format: nil))
        let dict = try XCTUnwrap(plist as? [String: Any])
        let dictLibraries = try XCTUnwrap(dict["libraries"] as? [[String: Any]])
        let libraries = dictLibraries.compactMap({ info -> Library? in
            if let name = info["name"] as? String,
               let type = info["licenseType"] as? String {
                return Library(name: name, type: type)
            }
            return nil
        }).sorted { $0.name < $1.name }
        XCTAssertEqual(libraries.count, 5)
        XCTAssertEqual(libraries[0], Library(name: "Package-A", type: "Unknown License"))
        XCTAssertEqual(libraries[1], Library(name: "Package-B", type: "Apache license 2.0"))
        XCTAssertEqual(libraries[2], Library(name: "Package-C", type: "MIT License"))
        XCTAssertEqual(libraries[3], Library(name: "Package-D", type: "BSD 3-clause Clear license"))
        XCTAssertEqual(libraries[4], Library(name: "Package-E", type: "zLib License"))
    }
}
#endif
