//
//  String+Extensions.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

extension StringProtocol {
    func match(_ pattern: String) -> [Range<Index>] {
        if let range = self.range(of: pattern, options: .regularExpression) {
            return [range] + self[range.upperBound...].match(pattern)
        }
        return []
    }
}

extension AttributedStringProtocol {
    func match(_ pattern: String) -> [Range<AttributedString.Index>] {
        if let range = self.range(of: pattern, options: .regularExpression) {
            return [range] + self[range.upperBound...].match(pattern)
        }
        return []
    }
}
