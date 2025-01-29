import Foundation
import Testing

#if os(macOS)
struct SourcePackagesParserTests {
    /// Returns path to the built products directory.
    private var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }
    
    private func directoryURL(_ key: String) -> URL? {
        Bundle.module.resourceURL?.appending(path: key).absoluteURL
    }
    
    @Test("If executed with invalid arguments, the command exits with instructions on how to use it.")
    func pass_invalid_arguments() throws {
        let sppBinary = productsDirectory.appending(path: "spp")
        let process = Process()
        process.executableURL = sppBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let actual = String(data: data, encoding: .utf8)

        let expect = "USAGE: swift run spp [output directory path] [SourcePackages directory path]\n"
        #expect(actual == expect)
        #expect(process.terminationStatus == 1)
    }
    
    @Test("If the workspace-state.json is broken, the command exits with error message.")
    func pass_broken_workspace_state() throws {
        let couldNotReadURL = try #require(directoryURL("CouldNotRead"))

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

        let expect = "Error: Could not read workspace-state.json.\n"
        #expect(actual == expect)
        #expect(process.terminationStatus == 1)
    }
    
    @Test("If the workspace-state.json is empty, the command exits with warning message.")
    func pass_empty_workspace_state() throws {
        let noLibrariesURL = try #require(directoryURL("Empty"))

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

        let expect = "Warning: No libraries.\n"
        #expect(actual == expect)
        #expect(process.terminationStatus == 0)
    }
    
    @Test(
        "If the file exporting fails, the command exits with error message.",
        .disabled("It is not possible to intentionally reproduce this error.")
    )
    func failed_to_export_license_list() {}
    
    @Test("If the workspace-state.json is full, the command exits normally.")
    func run() throws {
        let sourcePackagesURL = try #require(directoryURL("SourcePackages"))
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

        #expect(process.terminationStatus == 0)

        let ids = ["A", "B", "C", "D", "E"]
        let expect = ids.map { "Package-\($0)" }.joined(separator: "\n") + "\n"
        #expect(actual == expect)
        
        let text = try String(contentsOf: licenseListURL)
        let names = text.components(separatedBy: .newlines)
            .filter { $0.contains(#""name":"#) }
            .compactMap { $0.split(separator: ": ").last }

        #expect(names.count == 5)
        ids.enumerated().forEach { index, key in
            #expect(names[index].hasSuffix("\"Package-\(key)\","))
        }

        let urls = text.components(separatedBy: .newlines)
            .filter { $0.contains(#""url":"#) }
            .compactMap { $0.split(separator: ": ").last }

        #expect(urls.count == 5)
        ids.enumerated().forEach { index, key in
            #expect(urls[index].hasSuffix("\"https://github.com/dummy/Package-\(key).git\","))
        }
    }
}
#endif
