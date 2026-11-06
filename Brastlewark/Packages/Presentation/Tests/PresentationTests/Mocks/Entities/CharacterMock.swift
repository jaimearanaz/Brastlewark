@testable import Domain

extension Character {
    static func mock(
        id: Int = 1,
        name: String = "Mock Character",
        thumbnail: String = "mock-thumbnail",
        age: Int = 100,
        weight: Double = 50.0,
        height: Double = 120.0,
        hairColor: String = "Brown",
        professions: [String] = ["Carpenter", "Blacksmith"],
        friends: [String] = []
    ) -> Character {
        return Character(
            id: id,
            name: name,
            thumbnail: thumbnail,
            age: age,
            weight: weight,
            height: height,
            hairColor: hairColor,
            professions: professions,
            friends: friends
        )
    }
}
