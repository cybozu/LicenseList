import SwiftUI

extension Font {
    static var licenseBody: Font {
        #if os(iOS) || os(tvOS)
        .caption
        #else
        .body
        #endif
    }
}
