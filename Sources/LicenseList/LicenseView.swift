//
//  LicenseView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LicenseView: View {
    @State private var attributedLicenseBody = AttributedString(stringLiteral: "")

    @Environment(\.openURL) private var openURL: OpenURLAction
    @Environment(\.licenseListViewStyle) private var licenseListViewStyle: LicenseListViewStyle

    private let library: Library

    public init(library: Library) {
        self.library = library
    }

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
        ._licenseListViewStyle(licenseListViewStyle) {
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
