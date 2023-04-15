//
//  Library.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

public struct Library: Hashable {
    public let name: String
    public let licenseBody: String
}

extension Library {
    static public var libraries: [Library] {
        guard let fileURL = Bundle.main.url(forResource: "license-list", withExtension: "plist"),
              let data = try? Data(contentsOf: fileURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            return []
        }
        return (dict["libraries"] as? [[String: Any]])?.compactMap({ info -> Library? in
            guard let name = info["name"] as? String, let type = info["licenseType"] as? String else { return nil }
            return Library(name: name, licenseBody: body)
        }) ?? []
    }
}
