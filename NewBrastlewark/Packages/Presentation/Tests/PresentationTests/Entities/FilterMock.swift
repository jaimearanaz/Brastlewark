@testable import Domain

extension Filter {
    static func mock(
        age: ClosedRange<Int> = 0...100,
        weight: ClosedRange<Int> = 0...100,
        height: ClosedRange<Int> = 0...200,
        hairColor: Set<String> = ["Brown"],
        profession: Set<String> = ["Engineer"],
        friends: ClosedRange<Int> = 0...10
    ) -> Filter {
        return Filter(
            age: age,
            weight: weight,
            height: height,
            hairColor: hairColor,
            profession: profession,
            friends: friends
        )
    }
}
