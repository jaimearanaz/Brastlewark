import Foundation
import Testing

@testable import Data

final class CharacterEntityTests {
    @Test
    func given_validJSON_when_decoded_then_propertiesMatch() throws {
        // given
        let testBundle = Bundle.module
        guard let jsonURL = testBundle.url(forResource: "one_character", withExtension: "json") else {
            fatalError("one_character.json file not found in test bundle")
        }
        let json = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()

        // when
        let entity = try loadOneCharacterFromJSON()

        // then
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
        // given
        let testBundle = Bundle.module
        guard let jsonURL = testBundle.url(forResource: "empty_professions_character", withExtension: "json") else {
            fatalError("empty_professions_character.json file not found in test bundle")
        }
        let json = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()

        // when
        let entity = try decoder.decode(CharacterEntity.self, from: json)

        // then
        #expect(entity.professions == ["PROFESSION_NONE".localized])
    }

    @Test
    func given_invalidCharacters_when_cityDecoded_then_onlyValidCharactersAreReturned() throws {
        // given
        let json = """
        {
            "Brastlewark": [
                {
                    "id": 1, "name": "Valid One", "thumbnail": "one.png",
                    "age": 25, "weight": 70.5, "height": 120.0,
                    "hair_color": "Red", "professions": ["Carpenter"], "friends": []
                },
                {
                    "id": 2, "name": "Missing Age", "thumbnail": "two.png",
                    "weight": 80.0, "height": 125.0,
                    "hair_color": "Black", "professions": ["Miner"], "friends": []
                },
                {
                    "id": "invalid id", "name": "Invalid Type", "thumbnail": "three.png",
                    "age": 30, "weight": 75.0, "height": 123.0,
                    "hair_color": "Brown", "professions": ["Farmer"], "friends": []
                },
                {
                    "id": 4, "name": "Valid Two", "thumbnail": "four.png",
                    "age": 40, "weight": 90.0, "height": 130.0,
                    "hair_color": "Green", "professions": ["Brewer"], "friends": ["Valid One"]
                }
            ]
        }
        """
        let data = try #require(json.data(using: .utf8))

        // when
        let city = try JSONDecoder().decode(CityEntity.self, from: data)

        // then
        #expect(city.brastlewark.map(\.id) == [1, 4])
        #expect(city.brastlewark.map(\.name) == ["Valid One", "Valid Two"])
    }

    @Test
    func given_init_when_propertiesSet_then_valuesMatch() {
        // given
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

        // then
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
