//
//  View+Extensions.swift
//  
//
//  Created by ky0me22 on 2022/06/06.
//

import SwiftUI

extension View {
    func navigationBarRepositoryAnchorLink(action: @escaping () -> Void) -> some View {
        self.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    action()
                } label: {
                    Image(systemName: "link")
                }
            }
        }
    }
    
    func _licenseListViewStyle(_ style: LicenseListViewStyle, action: @escaping () -> Void) -> some View {
        Group {
            switch style {
            case .plain:
                self
            case .withRepositoryAnchorLink:
                self.navigationBarRepositoryAnchorLink(action: action)
            }
        }
    }
    
    public func licenseListViewStyle(_ style: LicenseListViewStyle) -> some View {
        self.environment(\.licenseListViewStyle, style)
    }
}
