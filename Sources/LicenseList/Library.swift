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
        return SPP.libraries.compactMap { info -> Library? in
            guard let name = info["name"],
                  let url = info["url"],
                  let body = info["licenseBody"] else {
                return nil
            }
            return Library(name: name, url: url, licenseBody: body)
        }
    }
}
