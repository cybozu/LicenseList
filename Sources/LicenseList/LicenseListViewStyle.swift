import SwiftUI

public enum LicenseListViewStyle {
    case plain
    case withRepositoryAnchorLink
}

struct LicenseListViewStyleEnvironmentKey: EnvironmentKey {
    typealias Value = LicenseListViewStyle

    static var defaultValue: LicenseListViewStyle = .plain
}

extension EnvironmentValues {
    var licenseListViewStyle: LicenseListViewStyle {
        get { self[LicenseListViewStyleEnvironmentKey.self] }
        set { self[LicenseListViewStyleEnvironmentKey.self] = newValue }
    }
}
