import Domain
import Foundation
import Testing

@testable import Data

struct CharacterEntityMapperTests {
    @Test
    func given_validCharacterEntity_when_map_then_returnsCorrectCharacter() {
        let entity = CharacterEntity.mock(
            id: 42,
            name: "Test Name",
            thumbnail: "test-thumbnail",
            age: 25,
            weight: 80.5,
            height: 180.0,
            hairColor: "Black",
            professions: ["Builder", "Miner"],
            friends: ["Alice", "Bob"]
        )
        let character = CharacterEntityMapper.map(entity: entity)
        #expect(character.id == entity.id)
        #expect(character.name == entity.name)
        #expect(character.thumbnail == entity.thumbnail)
        #expect(character.age == entity.age)
        #expect(character.weight == entity.weight)
        #expect(character.height == entity.height)
        #expect(character.hairColor == entity.hairColor)
        #expect(character.professions == entity.professions)
        #expect(character.friends == entity.friends)
    }

    @Test
    func given_characterEntityWithEmptyProfessionsAndFriends_when_map_then_returnsCharacterWithEmptyArrays() {
        let entity = CharacterEntity.mock(
            professions: [],
            friends: []
        )
        let character = CharacterEntityMapper.map(entity: entity)
        #expect(character.professions.isEmpty)
        #expect(character.friends.isEmpty)
    }
}
