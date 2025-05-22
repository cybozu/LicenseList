import Foundation

/// A structure that contains information about a library that the project depends on.
public struct Library: Identifiable, Hashable, Sendable {
    var sppLibrary: SPPLibrary

    /// The unique identifier.
    public var id: UUID = .init()
    /// The library name.
    public var name: String { sppLibrary.name }
    /// The repository url.
    public var url: URL? { URL(string: sppLibrary.url) }
    /// The license body.
    public var licenseBody: String { sppLibrary.licenseBody }

    init(sppLibrary: SPPLibrary) {
        self.sppLibrary = sppLibrary
    }

    /// - Parameters:
    ///   - name: The library name.
    ///   - url: The repository url.
    ///   - licenseBody: The license body.
    public init(name: String, url: String, licenseBody: String) {
        sppLibrary = .manual(name, url, licenseBody)
    }
}

extension Library {
    /// The libraries automatically collected by the internal plug-in.
    public static let libraries: [Library] = {
        SPPLibrary.allCases.map(Library.init(sppLibrary:))
    }()
}
