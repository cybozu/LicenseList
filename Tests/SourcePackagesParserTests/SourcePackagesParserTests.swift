import XCTest

#if os(macOS)
final class SourcePackagesParserTests: XCTestCase {
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
        Package-A
        Package-B
        Package-C
        Package-D
        Package-E

        """
        XCTAssertEqual(actual, expect)

        let licenseListURL = sourcePackagesURL.appendingPathComponent("license-list.plist")
        let plistData = try XCTUnwrap(Data(contentsOf: licenseListURL))
        let plist = try XCTUnwrap(PropertyListSerialization.propertyList(from: plistData, format: nil))
        let dict = try XCTUnwrap(plist as? [String: Any])
        let dictLibraries = try XCTUnwrap(dict["libraries"] as? [[String: Any]])
        let libraries = dictLibraries.compactMap({ $0["name"] as? String }).sorted { $0 < $1 }
        XCTAssertEqual(libraries.count, 5)
        XCTAssertEqual(libraries[0], "Package-A")
        XCTAssertEqual(libraries[1], "Package-B")
        XCTAssertEqual(libraries[2], "Package-C")
        XCTAssertEqual(libraries[3], "Package-D")
        XCTAssertEqual(libraries[4], "Package-E")
    }
}
#endif
