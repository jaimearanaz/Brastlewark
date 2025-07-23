import Domain
import Foundation

func loadCharactersFromJSON() throws -> [Character] {
    guard let url = Bundle.module.url(forResource: "get_all_characters", withExtension: "json") else {
        throw NSError(domain: "JSONUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find file JSON"])
    }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode([Character].self, from: data)
}
