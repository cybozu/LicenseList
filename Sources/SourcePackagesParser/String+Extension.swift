//
//  String+Extension.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

extension String {
    func replace(pattern: String, expect: String) -> String {
        return self.replacingOccurrences(of: pattern,
                                         with: expect,
                                         options: .regularExpression,
                                         range: self.range(of: self))
    }
}
