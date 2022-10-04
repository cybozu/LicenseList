import XCTest
@testable import LicenseList

final class LicenseListTests: XCTestCase {
    func testParsePlist() throws {
        let sut = LicenseListView(bundle: Bundle.module)

        XCTAssertEqual(sut.libraries.count, 5)

        XCTAssertEqual(sut.libraries[0].name, "Package-A")
        XCTAssertEqual(sut.libraries[0].licenseType, "Unknown License")

        XCTAssertEqual(sut.libraries[1].name, "Package-B")
        XCTAssertEqual(sut.libraries[1].licenseType, "Apache license 2.0")

        XCTAssertEqual(sut.libraries[2].name, "Package-C")
        XCTAssertEqual(sut.libraries[2].licenseType, "MIT License")

        XCTAssertEqual(sut.libraries[3].name, "Package-D")
        XCTAssertEqual(sut.libraries[3].licenseType, "BSD 3-clause Clear license")

        XCTAssertEqual(sut.libraries[4].name, "Package-E")
        XCTAssertEqual(sut.libraries[4].licenseType, "zLib License")
    }
}
