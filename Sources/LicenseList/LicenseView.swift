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
        GeometryReader { geometry in
            ScrollView {
                Text(attributedLicenseBody)
                    .font(.caption)
                    .padding()
                    .frame(width: geometry.size.width)
                    .padding(.leading, geometry.safeAreaInsets.leading)
                    .padding(.trailing, geometry.safeAreaInsets.trailing)
                    .onAppear {
                        attributedLicenseBody = attribute(library.licenseBody)
                    }
            }
            .ignoresSafeArea(edges: .horizontal)
        }
        .navigationBarTitle(library.name)
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
