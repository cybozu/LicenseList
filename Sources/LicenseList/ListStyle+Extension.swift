import SwiftUI

#if os(iOS)
extension ListStyle where Self == InsetGroupedListStyle {
    static var licenseList: Self { .insetGrouped }
}
#elseif os(macOS)
extension ListStyle where Self == InsetListStyle {
    static var licenseList: Self { .inset }
}
#else
extension ListStyle where Self == DefaultListStyle {
    static var licenseList: Self { .automatic }
}
#endif
