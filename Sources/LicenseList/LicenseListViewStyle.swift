//
//  LicenseListViewStyle.swift
//
//
//  Created by 宮本大新 on 2023/11/16.
//

import SwiftUI

public enum LicenseListViewStyle {
    case plain
    case withRepositoryAnchorLink
}

struct LicenseListViewStyleEnvironmentKey: EnvironmentKey {
    typealias Value = LicenseListViewStyle

    static var defaultValue: LicenseListViewStyle = .plain
}

extension EnvironmentValues {
    var licenseListViewStyle: LicenseListViewStyle {
        get { self[LicenseListViewStyleEnvironmentKey.self] }
        set { self[LicenseListViewStyleEnvironmentKey.self] = newValue }
    }
}
