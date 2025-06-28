import Domain
import Foundation

class CharactersRepository: CharactersRepositoryProtocol {
    private let networkService: NetworkServiceProtocol?
    private let cache: CharactersCacheProtocol

    init(networkService: NetworkServiceProtocol?, cache: CharactersCacheProtocol) {
        self.networkService = networkService
        self.cache = cache
    }

    func getAllCharacters(forceUpdate: Bool = false) async throws -> [Character] {
        do {
            if !forceUpdate, await cache.isValid(), let cached = await cache.get() {
                return cached.map { CharacterEntityMapper.map(entity: $0) }
            }

            guard let networkService = networkService else {
                throw CharactersRepositoryError.noInternetConnection
            }

            let characterEntities = try await networkService.getCharacters()
            await cache.save(characterEntities)
            return characterEntities.map { CharacterEntityMapper.map(entity: $0) }
        } catch {
            throw CharactersRepositoryError.unableToFetchCharacters
        }
    }
}
