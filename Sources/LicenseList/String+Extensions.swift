//
//  String+Extensions.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

import Foundation

extension StringProtocol {
    // For LicenseView
    func match(_ pattern: String) -> [Range<Index>] {
        if let range = self.range(of: pattern, options: .regularExpression) {
            return [range] + self[range.upperBound...].match(pattern)
        }
        return []
    }

    // For LegacyLicenseView
    func split(_ pattern: String) -> [LegacyLicenseSentence] {
        if let range = self.range(of: pattern, options: .regularExpression) {
            let res: [LegacyLicenseSentence] = [
                LegacyLicenseSentence(isHyperLink: false, body: String(self[..<range.lowerBound])),
                LegacyLicenseSentence(isHyperLink: true, body: String(self[range])),
            ] + self[range.upperBound...].split(pattern)
            return res.compactMap { $0.body.isEmpty ? nil : $0 }
        }
        return [LegacyLicenseSentence(isHyperLink: false, body: String(self))]
    }
}

@available(iOS 15, *)
extension AttributedStringProtocol {
    // For LicenseView
    func match(_ pattern: String) -> [Range<AttributedString.Index>] {
        if let range = self.range(of: pattern, options: .regularExpression) {
            return [range] + self[range.upperBound...].match(pattern)
        }
        return []
    }
}
