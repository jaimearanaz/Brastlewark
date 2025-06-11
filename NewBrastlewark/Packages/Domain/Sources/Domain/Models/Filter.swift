public struct Filter: Equatable, Sendable {
    public var age: ClosedRange<Int> = 0...0
    public var weight: ClosedRange<Int> = 0...0
    public var height: ClosedRange<Int> = 0...0
    public var hairColor = Set<String>()
    public var profession = Set<String>()
    public var friends: ClosedRange<Int> = 0...0

    static public func ==(lhs: Filter, rhs: Filter) -> Bool {
        return ((lhs.age == rhs.age) &&
        (lhs.weight == rhs.weight) &&
        (lhs.height == rhs.height) &&
        (lhs.friends == rhs.friends) &&
        (lhs.hairColor.sorted() == rhs.hairColor.sorted()) &&
        (lhs.profession.sorted() == rhs.profession.sorted()))
    }

    public init(
        age: ClosedRange<Int> = 0...0,
        weight: ClosedRange<Int> = 0...0,
        height: ClosedRange<Int> = 0...0,
        hairColor: Set<String> = Set<String>(),
        profession: Set<String> = Set<String>(),
        friends: ClosedRange<Int> = 0...0) {
        self.age = age
        self.weight = weight
        self.height = height
        self.hairColor = hairColor
        self.profession = profession
        self.friends = friends
    }
}
