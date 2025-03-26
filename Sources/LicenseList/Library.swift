import Foundation

/// A structure that contains information about a library that the project depends on.
public struct Library: Identifiable, Hashable {
    /// The unique identifier.
    public var id: UUID = .init()
    /// The library name.
    public var name: String
    /// The repository url.
    public var url: URL?
    /// The license body.
    public var licenseBody: String

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

extension Library:Equatable{
    public nonisolated static func == (lhs: Self, rhs: Self) -> Bool{
        lhs.id == rhs.id
    }
}

extension Library {
    /// The libraries automatically collected by the internal plug-in.
    public static var libraries: [Library] {
        SPP.libraries.compactMap { info -> Library? in
            guard let name = info["name"],
                  let url = info["url"],
                  let body = info["licenseBody"] else {
                return nil
            }
            return Library(name: name, url: url, licenseBody: body)
        }
    }
}
