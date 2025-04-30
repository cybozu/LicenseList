import Foundation

/// A structure that contains information about a library that the project depends on.
public struct Library: Identifiable, Hashable {
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
}

extension Library {
    /// The libraries automatically collected by the internal plug-in.
    public static var libraries: [Library] {
        SPPLibrary.allCases.map(Library.init)
    }
}
