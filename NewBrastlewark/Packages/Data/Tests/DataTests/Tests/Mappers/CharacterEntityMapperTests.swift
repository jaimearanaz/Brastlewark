import Domain
import Foundation
import Testing

@testable import Data

struct CharacterEntityMapperTests {
    @Test
    func given_validCharacterEntity_when_map_then_returnsCorrectCharacter() throws {
        // given
        let entity = try loadOneCharacterFromJSON()

        // when
        let character = CharacterEntityMapper.map(entity: entity)

        // then
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
        // given
        let entity = CharacterEntity.mock(
            professions: [],
            friends: []
        )

        // when
        let character = CharacterEntityMapper.map(entity: entity)

        // then
        #expect(character.professions.isEmpty)
        #expect(character.friends.isEmpty)
    }
}
