import Foundation

/// A structure that contains information about a library that the project depends on.
public struct Library: Identifiable, Hashable {
    /// The unique identifier.
    public let id: UUID = .init()
    /// The library name.
    public let name: String
    /// The repository url.
    public let url: URL?
    /// The license body.
    public let licenseBody: String

    /// Creates a library with the specified name, repository url, and license body.
    /// - Parameters:
    ///   - name: The library name.
    ///   - url: The repository url.
    ///   - licenseBody: The license body.
    public init(name: String, url: String, licenseBody: String) {
        self.name = name
        self.url = URL(string: url)
        self.licenseBody = licenseBody
    }
}

extension Library {
    /// The libraries automatically collected by the internal plug-in.
    public static var libraries: [Library] {
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
