import SwiftUI

extension View {
    /// Sets the style for license list view within this view.
    ///
    /// Use this modifier to set a specific style for license list view instances within a view:
    ///
    /// ```swift
    /// LicenseListView()
    ///     .licenseListViewStyle(.plain)
    /// ```
    public func licenseListViewStyle(_ style: some LicenseListViewStyle) -> some View {
        self.environment(\.licenseListViewStyle, style)
    }

    /// Sets the style for license views within this view.
    ///
    /// Use this modifier to set a specific style for license view instances within a view:
    ///
    /// ```swift
    /// ForEach(Library.libraries) { library in
    ///     LicenseView(library: library)
    /// }
    /// .licenseViewStyle(.plain)
    public func licenseViewStyle(_ style: some LicenseViewStyle) -> some View {
        self.environment(\.licenseViewStyle, style)
    }

    func navigationBarRepositoryAnchorLink(action: @escaping () -> Void) -> some View {
        self.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    action()
                } label: {
                    Image(systemName: "link")
                }
                .accessibilityIdentifier("repository_anchor_link")
            }
        }
    }
}
