//
//  LicenseView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

@available(iOS 15, *)
public struct LicenseView: View {
    @State private var attributedLicenseBody = AttributedString(stringLiteral: "")

    private let library: Library

    public init(library: Library) {
        self.library = library
    }

    public var body: some View {
        ScrollView {
            Text(attributedLicenseBody)
                .font(.caption)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .onAppear {
                    attributedLicenseBody = attribute(library.licenseBody)
                }
        }
        .navigationBarTitle(library.name)
    }

    private func attribute(_ inputText: String) -> AttributedString {
        var attributedText = AttributedString(inputText)
        let pattern: String = "https?://[A-Za-z0-9-._~:/?#\\[\\]@!$&'()*+,;%=]+"
        let urls: [URL?] = inputText.match(pattern)
            .map { URL(string: String(inputText[$0])) }
        let ranges = attributedText.match(pattern)
        for case (let range, let url?) in zip(ranges, urls) {
            attributedText[range].link = url
        }
        return attributedText
    }
}
