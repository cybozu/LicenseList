import SwiftUI

public enum LicenseViewStyle {
    case plain
    case withRepositoryAnchorLink
}

struct LicenseViewStyleKey: EnvironmentKey {
    static var defaultValue: LicenseViewStyle = .plain
}

extension EnvironmentValues {
    var licenseViewStyle: LicenseViewStyle {
        get { self[LicenseViewStyleKey.self] }
        set { self[LicenseViewStyleKey.self] = newValue }
    }
}
