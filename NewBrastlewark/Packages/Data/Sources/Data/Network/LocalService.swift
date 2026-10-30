import Foundation

final class LocalService: NetworkServiceProtocol {
    private let bundle: Bundle
    private let resourceName: String

    init(bundle: Bundle = .module, resourceName: String = "brastlewark") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    func getCharacters() async throws -> [CharacterEntity] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw NetworkErrors.wrongUrl
        }

        let data: Foundation.Data
        do {
            data = try Foundation.Data(contentsOf: url)
        } catch {
            throw NetworkErrors.general
        }

        guard let city = try? JSONDecoder().decode(CityEntity.self, from: data) else {
            throw NetworkErrors.wrongJson
        }

        return city.brastlewark
    }
}
