import Domain
import Foundation

class CharactersRepository: CharactersRepositoryProtocol {
    private let networkService: NetworkServiceProtocol?
    private let cache: CharactersCacheProtocol
    private var selectedCharacter: Character?

    init(networkService: NetworkServiceProtocol?, cache: CharactersCacheProtocol) {
        self.networkService = networkService
        self.cache = cache
        self.selectedCharacter = nil
    }

    func getAllCharacters(forceUpdate: Bool = false) async throws -> [Character] {
        if !forceUpdate, await cache.isValid(), let cached = await cache.get() {
            return cached.map { CharacterEntityMapper.map(entity: $0) }
        }

        guard let networkService = networkService else {
            throw NSError(
                domain: "CharactersRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "NetworkService is nil"])
        }

        let characterEntities = try await networkService.getCharacters()
        await cache.save(characterEntities)
        return characterEntities.map { CharacterEntityMapper.map(entity: $0) }
    }

    func saveSelectedCharacter(_ character: Character) async throws {
        selectedCharacter = character
    }

    func getSelectedCharacter() async throws -> Character? {
        return selectedCharacter
    }

    func deleteSelectedCharacter() async throws {
        selectedCharacter = nil
    }
}
