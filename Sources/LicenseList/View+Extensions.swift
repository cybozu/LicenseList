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
}
