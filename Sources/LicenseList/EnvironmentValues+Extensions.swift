import SwiftUI

extension EnvironmentValues {
    @Entry var licenseListViewStyle: any LicenseListViewStyle = DefaultLicenseListViewStyle()
    @Entry var licenseViewStyle: any LicenseViewStyle = DefaultLicenseViewStyle()
}
