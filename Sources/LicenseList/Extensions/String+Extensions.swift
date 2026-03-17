import Foundation

extension StringProtocol {
    func match(_ pattern: String) -> [Range<Index>] {
        guard let _range = range(of: pattern, options: .regularExpression) else {
            return []
        }
        return [_range] + self[_range.upperBound...].match(pattern)
    }
}

extension AttributedStringProtocol {
    func match(_ pattern: String) -> [Range<AttributedString.Index>] {
        guard let _range = range(of: pattern, options: .regularExpression) else {
            return []
        }
        return [_range] + self[_range.upperBound...].match(pattern)
    }
}
