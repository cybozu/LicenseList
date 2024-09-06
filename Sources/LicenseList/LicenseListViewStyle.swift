import SwiftUI

/// The properties of a license list view.
public struct LicenseListViewStyleConfiguration {
    /// An Array of library information.
    public let libraries: [Library]

    /// The closure to navigate for the given ``Library``.
    /// This is used when controlling navigation using a UINavigationController.
    public let navigationHandler: ((Library) -> Void)?

    /// The style that conforms to LicenseViewStyle.
    public let licenseViewStyle: any LicenseViewStyle

    init(
        libraries: [Library],
        navigationHandler: ((Library) -> Void)?,
        licenseViewStyle: any LicenseViewStyle
    ) {
        self.libraries = libraries
        self.navigationHandler = navigationHandler
        self.licenseViewStyle = licenseViewStyle
    }
}

/// A type that applies standard interaction behavior and a custom appearance to all license list views within a view hierarchy.
///
/// To configure the current license list view style for a view hierarchy, use the ``SwiftUI/View/licenseListViewStyle(_:)`` modifier.
/// Specify a style that conforms to LicenseListViewStyle when creating a license list view that uses the standard its interaction behavior defined for each platform.
public protocol LicenseListViewStyle: Sendable {
    /// A view that represents the body of a license list view.
    associatedtype Body: View

    /// Creates a view that represents the body of a license list view.
    /// - Parameters:
    ///   - configuration: The properties of the license list view.
    ///
    /// The system calls this method for each ``LicenseListView`` instance in a view hierarchy where this style is the current license list view style.
    @MainActor func makeBody(configuration: Configuration) -> Body

    /// The properties of a license list view.
    typealias Configuration = LicenseListViewStyleConfiguration
}

/// A license list view style that displays the list of libraries.
///
/// Selecting a library name in the list will navigate to the library details view.
/// You can also use ``PlainLicenseListViewStyle/plain`` to construct this style.
public struct PlainLicenseListViewStyle: LicenseListViewStyle {
    /// Creates a plain license list view style.
    public init() {}

    public func makeBody(configuration: PlainLicenseListViewStyle.Configuration) -> some View {
        List {
            ForEach(configuration.libraries) { library in
                if let navigationHandler = configuration.navigationHandler {
                    HStack {
                        Button {
                            navigationHandler(library)
                        } label: {
                            Text(library.name)
                        }
                        .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundColor(chevronGray)
                    }
                } else {
                    NavigationLink {
                        LicenseView(library: library)
                            .environment(\.licenseViewStyle, configuration.licenseViewStyle)
                    } label: {
                        Text(library.name)
                    }
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
    }

    private var chevronGray: Color {
        #if os(iOS)
        Color(.systemGray3)
        #else
        Color.gray
        #endif
    }
}

public extension LicenseListViewStyle where Self == PlainLicenseListViewStyle {
    /// A license list view style that displays the list of libraries.
    ///
    /// Selecting a library name in the list will navigate to the library details view.
    /// To apply this style to a license list view, use the ``SwiftUI/View/licenseListViewStyle(_:)`` modifier.
    static var plain: Self { Self() }
}

/// The default license list view style.
///
/// You can also use ``LicenseListViewStyle/automatic`` to construct this style.
public struct DefaultLicenseListViewStyle: LicenseListViewStyle {
    /// Creates a default license list view style.
    public init() {}

    public func makeBody(configuration: DefaultLicenseListViewStyle.Configuration) -> some View {
        PlainLicenseListViewStyle().makeBody(configuration: configuration)
    }
}

public extension LicenseListViewStyle where Self == DefaultLicenseListViewStyle {
    /// The default license list style.
    ///
    /// You can override a license list view's style.
    /// To apply the default style to a license list view, use the ``SwiftUI/View/licenseListViewStyle(_:)`` modifier.
    static var automatic: Self { Self() }
}
