import Foundation
import Testing

@testable import Data

final class CharacterEntityTests {
    @Test
    func given_validJSON_when_decoded_then_propertiesMatch() throws {
        let testBundle = Bundle.module
        guard let jsonURL = testBundle.url(forResource: "one_valid_character", withExtension: "json") else {
            fatalError("one_valid_character.json file not found in test bundle")
        }
        let json = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        let entity = try decoder.decode(CharacterEntity.self, from: json)
        #expect(entity.id == 1)
        #expect(entity.name == "Test Name")
        #expect(entity.thumbnail == "http://test.com/image.png")
        #expect(entity.age == 25)
        #expect(entity.weight == 70.5)
        #expect(entity.height == 120.0)
        #expect(entity.hairColor == "Red")
        #expect(entity.professions == ["Carpenter", "Farmer"])
        #expect(entity.friends == ["Friend1", "Friend2"])
    }

    @Test
    func given_emptyProfessions_when_decoded_then_professionNoneIsAdded() throws {
        let testBundle = Bundle.module
        guard let jsonURL = testBundle.url(forResource: "empty_professions_character", withExtension: "json") else {
            fatalError("empty_professions_character.json file not found in test bundle")
        }
        let json = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        let entity = try decoder.decode(CharacterEntity.self, from: json)
        #expect(entity.professions == ["PROFESSION_NONE".localized])
    }

    @Test
    func given_init_when_propertiesSet_then_valuesMatch() {
        let entity = CharacterEntity(
            id: 3,
            name: "Init Name",
            thumbnail: "thumb.png",
            age: 40,
            weight: 90.0,
            height: 140.0,
            hairColor: "Green",
            professions: ["Miner"],
            friends: ["FriendA"]
        )
        #expect(entity.id == 3)
        #expect(entity.name == "Init Name")
        #expect(entity.thumbnail == "thumb.png")
        #expect(entity.age == 40)
        #expect(entity.weight == 90.0)
        #expect(entity.height == 140.0)
        #expect(entity.hairColor == "Green")
        #expect(entity.professions == ["Miner"])
        #expect(entity.friends == ["FriendA"])
    }
}

struct Localizable {
    static func localized(_ key: String) -> String {
        return key
    }
}
