//
//  View+Extensions.swift
//  
//
//  Created by ky0me22 on 2022/06/06.
//

import SwiftUI

extension View {
    func listStyleInsetGroupedIfPossible() -> some View {
        Group {
            if #available(iOS 14, *) {
                self.listStyle(.insetGrouped)
            } else {
                self.listStyle(.grouped)
            }
        }
    }
    
    func navigationBarTitleInlineIfPossible<S>(_ title: S) -> some View where S : StringProtocol {
        Group {
            if #available(iOS 14, *) {
                self.navigationBarTitle(title, displayMode: .inline)
            } else {
                self.navigationBarTitle(title)
            }
        }
    }
    
    func navigationBarRepositoryAnchorLink(action: @escaping () -> Void) -> some View {
        Group {
            if #available(iOS 14, *) {
                self.toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            action()
                        } label: {
                            Image(systemName: "link")
                        }
                    }
                }
            } else {
                self.navigationBarItems(trailing: Button {
                    action()
                } label: {
                    Image(systemName: "link")
                })
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
