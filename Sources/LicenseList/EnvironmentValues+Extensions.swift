import SwiftUI

private struct LicenseListViewStyleKey: EnvironmentKey {
    static let defaultValue: any LicenseListViewStyle = DefaultLicenseListViewStyle()
}

private struct LicenseViewStyleKey: EnvironmentKey {
    static let defaultValue: any LicenseViewStyle = DefaultLicenseViewStyle()
}

extension EnvironmentValues {
    var licenseListViewStyle: any LicenseListViewStyle {
        get { self[LicenseListViewStyleKey.self] }
        set { self[LicenseListViewStyleKey.self] = newValue }
    }

    var licenseViewStyle: any LicenseViewStyle {
        get { self[LicenseViewStyleKey.self] }
        set { self[LicenseViewStyleKey.self] = newValue }
    }
}
