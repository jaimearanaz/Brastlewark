struct Filter: Equatable {

    var age: ClosedRange<Int> = 0...0
    var weight: ClosedRange<Int> = 0...0
    var height: ClosedRange<Int> = 0...0
    var hairColor = [String]()
    var profession = [String]()
    var friends: ClosedRange<Int> = 0...0

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return ((lhs.age == rhs.age) &&
        (lhs.weight == rhs.weight) &&
        (lhs.height == rhs.height) &&
        (lhs.friends == rhs.friends) &&
        (lhs.hairColor.sorted() == rhs.hairColor.sorted()) &&
        (lhs.profession.sorted() == rhs.profession.sorted()))
    }
}
