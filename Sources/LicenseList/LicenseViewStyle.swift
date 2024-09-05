import SwiftUI

public struct LicenseViewStyleConfiguration {
    public let library: Library
    public let numberOfLines: Int
    public let attributedLicenseBody: AttributedString
    public let openURL: (URL) -> Void

    init(
        library: Library,
        attributedLicenseBody: AttributedString,
        openURL: @escaping (URL) -> Void
    ) {
        self.library = library
        self.numberOfLines = library.licenseBody.components(separatedBy: .newlines).count
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
                .scrollableTextIfNeeded(numberOfLines: configuration.numberOfLines, font: .caption)
                .padding()
        }
        .clipShape(Rectangle())
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

// Style & Modifier For tvOS
private struct DummyFocusButtonStyle: ButtonStyle {
    let text: String
    let font: Font

    func makeBody(configuration: Configuration) -> some View {
        Text(text)
            .font(font)
            .hoverEffect()
            .opacity(0)
    }
}

private struct ScrollableTextIfNeededViewModifier: ViewModifier {
    private let numberOfButtons: Int
    private let text: String
    private let font: Font

    init(numberOfLines: Int, font: Font) {
        self.numberOfButtons = numberOfLines / 10
        self.text = [String](repeating: "#", count: 10).joined(separator: "\n")
        self.font = font
    }

    func body(content: Content) -> some View {
        #if os(tvOS)
        ZStack(alignment: .topLeading) {
            content
            VStack {
                ForEach(0 ..< numberOfButtons, id: \.self) { i in
                    Button("", action: {})
                        .buttonStyle(DummyFocusButtonStyle(text: text, font: font))
                }
            }
        }
        #else
        content
        #endif
    }
}

private extension View {
    func scrollableTextIfNeeded(numberOfLines: Int, font: Font) -> some View {
        self.modifier(ScrollableTextIfNeededViewModifier(numberOfLines: numberOfLines, font: font))
    }
}
