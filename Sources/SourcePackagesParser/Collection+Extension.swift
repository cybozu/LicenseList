extension Collection {
    var numberOfDigits: Int {
        precondition(count >= 0, "count must be non-negative.")
        return String(count).count
    }
}
