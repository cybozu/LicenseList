//
//  String+Extension.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

extension String {
    func replace(of regexPattern: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: regexPattern,
                                         with: replacement,
                                         options: .regularExpression,
                                         range: self.range(of: self))
    }
}
