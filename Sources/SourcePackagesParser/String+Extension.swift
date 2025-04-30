import Foundation

extension String {
    func replace(of regexPattern: String, with replacement: String) -> String {
        replacingOccurrences(of: regexPattern, with: replacement, options: .regularExpression, range: range(of: self))
    }

    func nest() -> String {
        components(separatedBy: .newlines)
            .map { $0.isEmpty ? "" : "    \($0)" }
            .joined(separator: "\n")
    }
}
