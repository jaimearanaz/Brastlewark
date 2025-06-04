extension Array where Element: Any & Hashable {
    func containsOneOrMoreOfElements(in array: [Element]) -> Bool {
        let firstSet = Set(self)
        let secondSet = Set(array)
        let inBoth = firstSet.intersection(secondSet)
        return inBoth.isNotEmpty
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
