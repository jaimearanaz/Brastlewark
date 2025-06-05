@testable import Data

extension CharacterEntity {
    static func mock(
        id: Int = 1,
        name: String = "Mock Character",
        thumbnail: String = "mock-thumbnail",
        age: Int = 100,
        weight: Double = 50.0,
        height: Double = 120.0,
        hairColor: String = "Brown",
        professions: [String] = ["Mock Profession"],
        friends: [String] = []
    ) -> CharacterEntity {
        return CharacterEntity(
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
