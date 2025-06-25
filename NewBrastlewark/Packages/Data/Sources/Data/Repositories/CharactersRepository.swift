import Domain
import Foundation

class CharactersRepository: CharactersRepositoryProtocol {
    private let networkService: NetworkServiceProtocol?
    private let cache: CharactersCacheProtocol
    private var selectedCharacterId: Int?

    init(networkService: NetworkServiceProtocol?, cache: CharactersCacheProtocol) {
        self.networkService = networkService
        self.cache = cache
        self.selectedCharacterId = nil
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

    func saveSelectedCharacter(id: Int) async throws {
        selectedCharacterId = id
    }

    func getSelectedCharacter() async throws -> Int? {
        return selectedCharacterId
    }

    func deleteSelectedCharacter() async throws {
        selectedCharacterId = nil
    }
}
