//
//  LegacyLicenseView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LegacyLicenseView: View {
    @State private var sentences = [LegacyLicenseSentence]()

    private let library: Library

    public init(library: Library) {
        self.library = library
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(sentences, id: \.body) { sentence in
                    if sentence.isHyperLink {
                        hyperLinkText(sentence.body)
                    } else {
                        Text(sentence.body)
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            sentences = resolve(library.licenseBody)
        }
        .navigationBarTitleInlineIfPossible(library.name)
    }

    private func hyperLinkText(_ linkText: String) -> some View {
        Text(linkText)
            .font(.caption)
            .foregroundColor(Color.blue)
            .onTapGesture {
                if let url = URL(string: linkText),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
    }

    private func resolve(_ inputText: String) -> [LegacyLicenseSentence] {
        let pattern: String = "https?://[A-Za-z0-9\\.\\-\\[\\]!@#$%&=+/?:_]+"
        return inputText.split(pattern)
    }
}
