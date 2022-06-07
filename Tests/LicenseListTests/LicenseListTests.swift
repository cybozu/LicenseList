import XCTest
@testable import LicenseList

final class LicenseListTests: XCTestCase {

    func testParsePlist() throws {
        let url = Bundle.module.url(forResource: "license-list", withExtension: "plist")!
        let sut = LicenseListView(fileURL: url)

        XCTAssertEqual(sut.libraries.count, 2)
        XCTAssertEqual(sut.libraries[0].name, "KeychainAccess")
        XCTAssertEqual(sut.libraries[0].licenseType, "MIT License")
        XCTAssertEqual(sut.libraries[1].name, "swift-argument-parser")
        XCTAssertEqual(sut.libraries[1].licenseType, "Apache license 2.0")
    }
}
