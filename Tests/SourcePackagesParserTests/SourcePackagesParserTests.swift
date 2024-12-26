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
        Bundle.module.resourceURL?.appending(path: key).absoluteURL
    }

    func test_invalid_args() throws {
        let sppBinary = productsDirectory.appending(path: "spp")
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

        let sppBinary = productsDirectory.appending(path: "spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [
            couldNotReadURL.appending(path: "LicenseList.swift").path(),
            couldNotReadURL.path()
        ]
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

        print("🦩", noLibrariesURL.path())

        let sppBinary = productsDirectory.appending(path: "spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [
            noLibrariesURL.appending(path: "LicenseList.swift").path(),
            noLibrariesURL.path()
        ]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 0)
        let expect = "Warning: No libraries.\n"
        XCTAssertEqual(actual, expect)
    }

    func xtest_CouldNotExportLicenseList() throws {
        // It is not possible to intentionally reproduce this error.
    }

    func test_SourcePackagesParser_run() throws {
        let sourcePackagesURL = try XCTUnwrap(directoryURL("SourcePackages"))
        let licenseListURL = sourcePackagesURL.appending(path: "LicenseList.swift")

        let sppBinary = productsDirectory.appending(path: "spp")
        let process = Process()
        process.executableURL = sppBinary
        process.arguments = [
            licenseListURL.path(),
            sourcePackagesURL.path()
        ]
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        XCTAssertEqual(process.terminationStatus, 0)

        let ids = ["A", "B", "C", "D", "E"]
        let expect = ids.map { "Package-\($0)" }.joined(separator: "\n") + "\n"
        XCTAssertEqual(actual, expect)

        let text = try XCTUnwrap(String(contentsOf: licenseListURL))
        let names = text.components(separatedBy: .newlines)
            .filter { $0.contains(#""name":"#) }
            .compactMap { $0.split(separator: ": ").last }

        XCTAssertEqual(names.count, 5)
        ids.enumerated().forEach { (index, key) in
            XCTAssertTrue(names[index].hasSuffix("\"Package-\(key)\","))
        }

        let urls = text.components(separatedBy: .newlines)
            .filter { $0.contains(#""url":"#) }
            .compactMap { $0.split(separator: ": ").last }

        XCTAssertEqual(urls.count, 5)
        ids.enumerated().forEach { (index, key) in
            XCTAssertTrue(urls[index].hasSuffix("\"https://github.com/dummy/Package-\(key).git\","))
        }
    }
}
#endif
