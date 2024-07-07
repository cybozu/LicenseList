import SwiftUI

extension View {
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
    
    func _licenseViewStyle(_ style: LicenseViewStyle, action: @escaping () -> Void) -> some View {
        Group {
            switch style {
            case .plain:
                self
            case .withRepositoryAnchorLink:
                self.navigationBarRepositoryAnchorLink(action: action)
            }
        }
    }
    
    public func licenseViewStyle(_ style: LicenseViewStyle) -> some View {
        self.environment(\.licenseViewStyle, style)
    }
}
