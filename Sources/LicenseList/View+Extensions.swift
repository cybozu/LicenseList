import SwiftUI

extension View {
    /// Sets the style for license list view within this view.
    public func licenseListViewStyle(_ style: some LicenseListViewStyle) -> some View {
        self.environment(\.licenseListViewStyle, style)
    }

    /// Sets the style for license views within this view.
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
            }
        }
    }
}
