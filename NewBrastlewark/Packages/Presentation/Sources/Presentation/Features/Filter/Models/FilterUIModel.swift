public struct FilterUIModel {
    var available: OneFilterUIModel = OneFilterUIModel()
    var active: OneFilterUIModel = OneFilterUIModel()

    public init(
        available: OneFilterUIModel = OneFilterUIModel(),
        active: OneFilterUIModel = OneFilterUIModel()) {
        self.available = available
        self.active = active
    }
}

public struct OneFilterUIModel: Equatable, Sendable {
    var age: ClosedRange<Int> = 0...0
    var weight: ClosedRange<Int> = 0...0
    var height: ClosedRange<Int> = 0...0
    var hairColor = Set<String>()
    var profession = Set<String>()
    var friends: ClosedRange<Int> = 0...0

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

