//
//  LicenseListView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LicenseListView: View {
    @Environment(\.licenseListViewStyle) private var licenseListViewStyle: LicenseListViewStyle

    let libraries = Library.libraries
    let navigationHandler: ((Library) -> Void)?

    public init(navigationHandler: ((Library) -> Void)? = nil) {
        self.navigationHandler = navigationHandler
    }

    public var body: some View {
        List {
            ForEach(libraries) { library in
                if let navigationHandler {
                    HStack {
                        Button {
                            navigationHandler(library)
                        } label: {
                            Text(library.name)
                        }
                        .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundColor(Color(.systemGray3))
                    }
                } else {
                    NavigationLink {
                        LicenseView(library: library)
                            .licenseListViewStyle(licenseListViewStyle)
                    } label: {
                        Text(library.name)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
