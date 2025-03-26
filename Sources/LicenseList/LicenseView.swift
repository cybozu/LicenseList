import SwiftUI

/// A view that displays license body.
public struct LicenseView: View {
    @State private var attributedLicenseBody = AttributedString(stringLiteral: "")

    @Environment(\.licenseViewStyle) private var _licenseViewStyle
    @Environment(\.openURL) private var openURL: OpenURLAction

    private var library: Library

    /// Creates new license view with the specified library.
    /// - Parameters:
    ///   - library: The library to use in this view.
    public init(library: Library) {
        self.library = library
    }

    /// The content and behavior of the license view.
    public var body: some View {
        AnyView(_licenseViewStyle.makeBody(configuration: .init(
            library: library,
            attributedLicenseBody: attributedLicenseBody,
            openURL: { openURL($0) }
        )))
        .onAppear {
            attributedLicenseBody = attribute(library.licenseBody)
        }
        .onChange(of:library){ newValue in
            attributedLicenseBody = attribute(newValue.licenseBody)
        }
        .accessibilityIdentifier("license_view")
    }

    private func attribute(_ inputText: String) -> AttributedString {
        var attributedText = AttributedString(inputText)
        let urls: [URL?] = inputText.match(URL.regexPattern)
            .map { URL(string: String(inputText[$0])) }
        let ranges = attributedText.match(URL.regexPattern)
        for case (let range, let url?) in zip(ranges, urls) {
            attributedText[range].link = url
        }
        return attributedText
    }
}
