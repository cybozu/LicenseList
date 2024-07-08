import SwiftUI

/// A style for license views.
public enum LicenseViewStyle: Sendable {
    /// The style used to display just the license body.
    case plain
    /// The style used to display the license body and repository anchor link.
    case withRepositoryAnchorLink
}

struct LicenseViewStyleKey: EnvironmentKey {
    static let defaultValue: LicenseViewStyle = .plain
}

extension EnvironmentValues {
    var licenseViewStyle: LicenseViewStyle {
        get { self[LicenseViewStyleKey.self] }
        set { self[LicenseViewStyleKey.self] = newValue }
    }
}
