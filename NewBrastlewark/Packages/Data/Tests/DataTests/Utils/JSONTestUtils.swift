import Foundation

@testable import Data

func loadCharactersNoProfessionFromJSON() throws -> CharacterEntity {
    guard let url = Bundle.module.url(forResource: "empty_professions_character", withExtension: "json") else {
        throw NSError(domain: "JSONTestUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file empty_professions_character.json"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CharacterEntity.self, from: data)
}

func loadCharactersFromJSON() throws -> [CharacterEntity] {
    guard let url = Bundle.module.url(forResource: "characters", withExtension: "json") else {
        throw NSError(domain: "JSONTestUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file characters.json"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CityEntity.self, from: data).brastlewark
}

func loadOneCharacterFromJSON() throws -> CharacterEntity {
    guard let url = Bundle.module.url(forResource: "one_character", withExtension: "json") else {
        throw NSError(domain: "JSONTestUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file one_character.json"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CharacterEntity.self, from: data)
}
