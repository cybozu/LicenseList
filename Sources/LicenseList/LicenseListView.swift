//
//  LicenseListView.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import SwiftUI

public struct LicenseListView: View {
    let libraries: [Library]

    public init(fileURL: URL) {
        guard let data = try? Data(contentsOf: fileURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            libraries = []
            return
        }
        let _libraries = (dict["libraries"] as? [[String: Any]])?.compactMap({ info -> Library? in
            guard let name = info["name"] as? String,
                  let type = info["licenseType"] as? String,
                  let body = info["licenseBody"] as? String else {
                return nil
            }
            return Library(name: name,
                           licenseType: type,
                           licenseBody: body)
        })
        guard let libraries = _libraries else {
            libraries = []
            return
        }
        self.libraries = libraries
    }

    public var body: some View {
        List {
            ForEach(libraries, id: \.name) { library in
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
        .listStyleInsetGroupedIfPossible()
    }
}
