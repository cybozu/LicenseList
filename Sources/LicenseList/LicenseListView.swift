//
//  LicenseListView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import UIKit
import SwiftUI

public struct LicenseListView: View {
    let libraries: [Library]
    let useUINavigationController: Bool
    let navigationHandler: ((Library) -> Void)?

    public init(
        fileURL: URL,
        useUINavigationController: Bool = false,
        navigationHandler: ((Library) -> Void)? = nil
    ) {
        self.useUINavigationController = useUINavigationController
        self.navigationHandler = navigationHandler
        guard let data = try? Data(contentsOf: fileURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            libraries = []
            return
        }
        libraries = (dict["libraries"] as? [[String: Any]])?.compactMap({ info -> Library? in
            guard let name = info["name"] as? String,
                  let url = info["url"] as? String,
                  let body = info["licenseBody"] as? String else {
                return nil
            }
            return Library(name: name, url: url, licenseBody: body)
        }) ?? []
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
        .listStyleInsetGroupedIfPossible()
    }

    @ViewBuilder
    func libraryNavigationLink(_ library: Library) -> some View {
        if #available(iOS 15, *) {
            NavigationLink(destination: LicenseView(library: library)) {
                Text(library.name)
            }
        } else {
            NavigationLink(destination: LegacyLicenseView(library: library)) {
                Text(library.name)
            }
        }
    }
}

public extension LicenseListView {
    init(bundle: Bundle = .main, useUINavigationController: Bool = false) {
        let url = bundle.url(forResource: "license-list", withExtension: "plist") ?? URL(fileURLWithPath: "/")
        self.init(fileURL: url, useUINavigationController: useUINavigationController, navigationHandler: { _ in })
    }
}
