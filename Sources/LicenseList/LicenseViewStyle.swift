import SwiftUI

/// The properties of a license view.
public struct LicenseViewStyleConfiguration {
    /// The library information.
    public let library: Library

    /// The number of lines in the license body.
    public let numberOfLines: Int

    /// The license body where in-text links work.
    public let attributedLicenseBody: AttributedString

    /// An action that opens a URL.
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

/// A type that applies standard interaction behavior and a custom appearance to all license views within a view hierarchy.
///
/// To configure the current license view style for a view hierarchy, use the ``SwiftUI/View/licenseViewStyle(_:)`` modifier.
/// Specify a style that conforms to LicenseViewStyle when creating a license view that uses the standard its interaction behavior defined for each platform.
public protocol LicenseViewStyle: Sendable {
    /// A view that represents the body of a license view.
    associatedtype Body: View

    /// Creates a view that represents the body of a license view.
    /// - Parameters:
    ///   - configuration: The properties of the license view.
    ///
    /// The system calls this method for each ``LicenseView`` instance in a view hierarchy where this style is the current license view style.
    @MainActor func makeBody(configuration: Configuration) -> Body

    /// The properties of a license view.
    typealias Configuration = LicenseViewStyleConfiguration
}

/// A license view style that only displays the license body.
///
/// Links in the text will open in external apps.
/// You can also use ``PlainLicenseViewStyle/plain`` to construct this style.
public struct PlainLicenseViewStyle: LicenseViewStyle {
    /// Creates a plain license view style.
    public init() {}

    public func makeBody(configuration: PlainLicenseViewStyle.Configuration) -> some View {
        ScrollView {
            Text(configuration.attributedLicenseBody)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                #if os(tvOS)
                .scrollableText(numberOfLines: configuration.numberOfLines, font: .caption)
                #endif
                .padding()
        }
        .clipShape(Rectangle())
        .navigationBarTitle(configuration.library.name)
    }
}

public extension LicenseViewStyle where Self == PlainLicenseViewStyle {
    /// A license view style that only displays the license body.
    ///
    /// Links in the text will open in external apps.
    /// To apply this style to a license view, use the ``SwiftUI/View/licenseViewStyle(_:)`` modifier.
    static var plain: Self { Self() }
}

/// A license view style with repository anchor link.
///
/// This style is based on the plain style.
/// Links in the text will open in external apps.
/// In addition, a button linking to the library's repository places in the right corner of the navigation bar.
/// You can also use ``WithRepositoryAnchorLinkLicenseViewStyle/withRepositoryAnchorLink`` to construct this style.
public struct WithRepositoryAnchorLinkLicenseViewStyle: LicenseViewStyle {
    /// Creates a license view style with repository anchor link.
    public init() {}

    public func makeBody(configuration: WithRepositoryAnchorLinkLicenseViewStyle.Configuration) -> some View {
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
    /// A license view style with repository anchor link.
    ///
    /// This style is based on the plain style.
    /// Links in the text will open in external apps.
    /// In addition, a button linking to the library's repository places in the right corner of the navigation bar.
    /// To apply this style to a license view, or to a view that contains license views, use the ``SwiftUI/View/licenseViewStyle(_:)`` modifier.
    static var withRepositoryAnchorLink: Self { Self() }
}

/// The default license view style.
///
/// You can also use ``LicenseViewStyle/automatic`` to construct this style.
public struct DefaultLicenseViewStyle: LicenseViewStyle {
    /// Creates a default license view style.
    public init() {}

    /// Creates a view that represents the body of a license view.
    /// - Parameters:
    ///   - configuration: The properties of the license view.
    ///
    /// The system calls this method for each ``LicenseView`` instance in a view hierarchy where this style is the current license view style.
    public func makeBody(configuration: DefaultLicenseViewStyle.Configuration) -> some View {
        PlainLicenseViewStyle().makeBody(configuration: configuration)
    }
}

public extension LicenseViewStyle where Self == DefaultLicenseViewStyle {
    /// The default license style.
    ///
    /// You can override a license view's style.
    /// To apply the default style to a license view, or to a view that contains license views, use the ``SwiftUI/View/licenseViewStyle(_:)`` modifier.
    static var automatic: Self { Self() }
}

// Style & Modifier For tvOS
#if os(tvOS)
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

private struct ScrollableTextViewModifier: ViewModifier {
    private let numberOfButtons: Int
    private let text: String
    private let font: Font

    init(numberOfLines: Int, font: Font) {
        self.numberOfButtons = numberOfLines / 10
        self.text = [String](repeating: "#", count: 10).joined(separator: "\n")
        self.font = font
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            content
            VStack {
                ForEach(0 ..< numberOfButtons, id: \.self) { i in
                    Button("", action: {})
                        .buttonStyle(DummyFocusButtonStyle(text: text, font: font))
                }
            }
        }
    }
}

private extension View {
    func scrollableText(numberOfLines: Int, font: Font) -> some View {
        self.modifier(ScrollableTextViewModifier(numberOfLines: numberOfLines, font: font))
    }
}
#endif
