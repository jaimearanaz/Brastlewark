import Foundation

@testable import Data

func loadCharactersNoProfessionFromJSON() throws -> CharacterEntity {
    let url = Bundle.module.url(forResource: "empty_professions_character", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CharacterEntity.self, from: data)
}

func loadCharactersFromJSON() throws -> [CharacterEntity] {
    let url = Bundle.module.url(forResource: "characters", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CityEntity.self, from: data).brastlewark
}


func loadOneCharacterFromJSON() throws -> CharacterEntity {
    let url = Bundle.module.url(forResource: "one_character", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(CharacterEntity.self, from: data)
}
