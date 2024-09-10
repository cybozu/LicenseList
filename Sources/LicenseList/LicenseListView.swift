import SwiftUI

/// A view that presents license views in a list format.
public struct LicenseListView: View {
    @Environment(\.licenseListViewStyle) private var _licenseListViewStyle
    @Environment(\.licenseViewStyle) private var _licenseViewStyle

    let libraries = Library.libraries
    let navigationHandler: ((Library) -> Void)?

    /// Creates new license list view.
    /// - Parameters:
    ///   - navigationHandler: The closure to navigate for the given ``Library``.
    ///     This is used when controlling navigation using a UINavigationController.
    public init(navigationHandler: ((Library) -> Void)? = nil) {
        self.navigationHandler = navigationHandler
    }

    /// The content and behavior of the license list view.
    public var body: some View {
        AnyView(_licenseListViewStyle.makeBody(configuration: .init(
            libraries: libraries,
            navigationHandler: navigationHandler,
            licenseViewStyle: _licenseViewStyle
        )))
        .accessibilityIdentifier("license_list_view")
    }
}
