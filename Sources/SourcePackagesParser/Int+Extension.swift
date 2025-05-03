import Foundation

extension Int {
    var numberOfDigits: Int {
        if self == .zero {
            .zero
        } else {
            Int(log10(Double(self))) + 1
        }
    }
}
