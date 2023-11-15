//
//  Library.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

public struct Library: Identifiable, Hashable {
    public let id: UUID = .init()
    public let name: String
    public let url: URL?
    public let licenseBody: String

    public init(name: String, url: String, licenseBody: String) {
        self.name = name
        self.url = URL(string: url)
        self.licenseBody = licenseBody
    }
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
            guard let name = info["name"] as? String,
                  let url = info["url"] as? String,
                  let body = info["licenseBody"] as? String else {
                return nil
            }
            return Library(name: name, url: url, licenseBody: body)
        }) ?? []
    }
}
