import SwiftUI

/// A view that displays license body.
public struct LicenseView: View {
    @State private var attributedLicenseBody = AttributedString(stringLiteral: "")

    @Environment(\.openURL) private var openURL: OpenURLAction
    @Environment(\.licenseViewStyle) private var licenseViewStyle: LicenseViewStyle

    private let library: Library

    /// Creates new license list view with the specified library.
    /// - Parameters:
    ///   - library: The library to use in this view.
    public init(library: Library) {
        self.library = library
    }

    /// The content and behavior of the license view.
    public var body: some View {
        ScrollView {
            Text(attributedLicenseBody)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onAppear {
                    attributedLicenseBody = attribute(library.licenseBody)
                }
        }
        .navigationBarTitle(library.name)
        ._licenseViewStyle(licenseViewStyle) {
            if let url = library.url {
                openURL(url)
            }
        }
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
