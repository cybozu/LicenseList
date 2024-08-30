import SwiftUI

public struct LicenseListViewStyleConfiguration {
    public let libraries: [Library]
    public let navigationHandler: ((Library) -> Void)?
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

public protocol LicenseListViewStyle: Sendable {
    associatedtype Body: View

    @MainActor 
    func makeBody(configuration: LicenseListViewStyleConfiguration) -> Body
}

public struct PlainLicenseListViewStyle: LicenseListViewStyle {
    public func makeBody(configuration: LicenseListViewStyleConfiguration) -> some View {
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
    static var plain: Self { Self() }
}

public struct DefaultLicenseListViewStyle: LicenseListViewStyle {
    public init() {}

    public func makeBody(configuration: LicenseListViewStyleConfiguration) -> some View {
        PlainLicenseListViewStyle().makeBody(configuration: configuration)
    }
}

public extension LicenseListViewStyle where Self == DefaultLicenseListViewStyle {
    static var automatic: Self { Self() }
}
