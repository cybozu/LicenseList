//
//  Library.swift
//
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

public struct Library: Hashable {
    public let name: String
    public let licenseType: String
    public let licenseBody: String
}

extension Library {
    static public var licenses: [Library] {
        var libraries: [Library] = []
        guard let fileURL = Bundle.main.url(forResource: "license-list", withExtension: "plist"),
              let data = try? Data(contentsOf: fileURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dict = plist as? [String: Any] else {
            return libraries
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
        guard let libraries = _libraries else { return libraries }
        return libraries
    }
}
