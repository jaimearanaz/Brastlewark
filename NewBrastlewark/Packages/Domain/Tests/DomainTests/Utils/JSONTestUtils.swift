import Foundation

@testable import Domain

func loadCharactersFromJSON() throws -> [Character] {
    let url = Bundle.module.url(forResource: "characters", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode([Character].self, from: data)
}

func loadOneCharacterFromJSON() throws -> Character {
    let url = Bundle.module.url(forResource: "one_character", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(Character.self, from: data)
}
