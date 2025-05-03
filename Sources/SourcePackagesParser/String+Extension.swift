import Foundation

extension String {
    func indented() -> String {
        components(separatedBy: .newlines)
            .map { $0.isEmpty ? "" : "    \($0)" }
            .joined(separator: "\n")
    }

    func nested() -> String {
        isEmpty ? "" : "\n\(self)\n"
    }
}
