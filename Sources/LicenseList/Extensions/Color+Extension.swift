import SwiftUI

extension Color {
    static var chevron: Color {
        #if os(iOS)
        Color(.systemGray3)
        #else
        Color.gray
        #endif
    }
}
