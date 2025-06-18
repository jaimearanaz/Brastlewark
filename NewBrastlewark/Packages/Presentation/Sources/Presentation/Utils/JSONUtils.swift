import Domain
import Foundation

func loadCharactersFromJSON() throws -> [Character] {
    let url = Bundle.module.url(forResource: "get_all_characters", withExtension: "json")!
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode([Character].self, from: data)
}
