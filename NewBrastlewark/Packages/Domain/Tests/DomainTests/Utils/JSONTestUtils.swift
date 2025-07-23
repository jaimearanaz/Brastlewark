import Foundation

@testable import Domain

func loadCharactersFromJSON() throws -> [Character] {
    guard let url = Bundle.module.url(forResource: "characters", withExtension: "json") else {
        throw NSError(domain: "JSONTestUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file characters.json"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode([Character].self, from: data)
}

func loadOneCharacterFromJSON() throws -> Character {
    guard let url = Bundle.module.url(forResource: "one_character", withExtension: "json") else {
        throw NSError(domain: "JSONTestUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file one_character.json"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(Character.self, from: data)
}
