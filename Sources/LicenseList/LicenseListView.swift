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
    let useUINavigationController: Bool
    let navigationHandler: ((Library) -> Void)?

    public init(
        useUINavigationController: Bool = false,
        navigationHandler: ((Library) -> Void)? = nil
    ) {
        self.useUINavigationController = useUINavigationController
        self.navigationHandler = navigationHandler
    }

    public var body: some View {
        List {
            ForEach(libraries) { library in
                if useUINavigationController {
                    HStack {
                        Button {
                            navigationHandler?(library)
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
                    libraryNavigationLink(library)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    func libraryNavigationLink(_ library: Library) -> some View {
        if #available(iOS 15, *) {
            NavigationLink {
                LicenseView(library: library)
                    .licenseListViewStyle(licenseListViewStyle)
            } label: {
                Text(library.name)
            }
        } else {
            NavigationLink {
                LegacyLicenseView(library: library)
                    .licenseListViewStyle(licenseListViewStyle)
            } label: {
                Text(library.name)
            }
        }
    }
}

public extension LicenseListView {
    init(useUINavigationController: Bool = false) {
        self.init(useUINavigationController: useUINavigationController, navigationHandler: { _ in })
    }
}
