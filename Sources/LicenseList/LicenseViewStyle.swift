import SwiftUI

public struct LicenseViewStyleConfiguration {
    public let library: Library
    public let attributedLicenseBody: AttributedString
    public let openURL: (URL) -> Void

    init(
        library: Library,
        attributedLicenseBody: AttributedString,
        openURL: @escaping (URL) -> Void
    ) {
        self.library = library
        self.attributedLicenseBody = attributedLicenseBody
        self.openURL = openURL
    }
}

public protocol LicenseViewStyle: Sendable {
    associatedtype Body: View

    @MainActor
    func makeBody(configuration: LicenseViewStyleConfiguration) -> Body
}

public struct PlainLicenseViewStyle: LicenseViewStyle {
    public func makeBody(configuration: LicenseViewStyleConfiguration) -> some View {
        ScrollView {
            Text(configuration.attributedLicenseBody)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationBarTitle(configuration.library.name)
    }
}

public extension LicenseViewStyle where Self == PlainLicenseViewStyle {
    static var plain: Self { Self() }
}

public struct WithRepositoryAnchorLinkLicenseViewStyle: LicenseViewStyle {
    public func makeBody(configuration: LicenseViewStyleConfiguration) -> some View {
        PlainLicenseViewStyle()
            .makeBody(configuration: configuration)
            .navigationBarRepositoryAnchorLink {
                if let url = configuration.library.url {
                    configuration.openURL(url)
                }
            }
    }
}

public extension LicenseViewStyle where Self == WithRepositoryAnchorLinkLicenseViewStyle {
    static var withRepositoryAnchorLink: Self { Self() }
}

public struct DefaultLicenseViewStyle: LicenseViewStyle {
    public init() {}

    public func makeBody(configuration: LicenseViewStyleConfiguration) -> some View {
        PlainLicenseViewStyle().makeBody(configuration: configuration)
    }
}

public extension LicenseViewStyle where Self == DefaultLicenseViewStyle {
    static var automatic: Self { Self() }
}
