//
//  LegacyLicenseView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LegacyLicenseView: View {
    @State private var lines = [[LegacyLicenseSentence]]()

    @Environment(\.licenseListViewStyle) private var licenseListViewStyle: LicenseListViewStyle

    private let library: Library

    public init(library: Library) {
        self.library = library
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(lines.indices, id: \.self) { index in
                    if lines[index].count == 1,
                       let sentence = lines[index].first {
                        Text(sentence.body)
                            .font(.caption)
                    } else {
                        lines[index].reduce(Text("")) { result, sentence in
                            if sentence.isHyperLink {
                                return result + Text(sentence.body)
                                    .font(.caption)
                                    .foregroundColor(Color.blue)
                            } else {
                                return result + Text(sentence.body)
                                    .font(.caption)
                            }
                        }
                        .onTapGesture {
                            if let linkText = lines[index].first(where: { $0.isHyperLink })?.body,
                               let url = URL(string: linkText),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .onAppear {
            lines = resolve(library.licenseBody)
        }
        .navigationBarTitle(library.name, displayMode: .inline)
        ._licenseListViewStyle(licenseListViewStyle) {
            if let url = library.url {
                UIApplication.shared.open(url)
            }
        }
    }

    private func resolve(_ inputText: String) -> [[LegacyLicenseSentence]] {
        return inputText
            .components(separatedBy: .newlines)
            .map { $0.split(URL.regexPattern) }
    }
}
