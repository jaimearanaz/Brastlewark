import Combine
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
        if !forceUpdate, cache.isValid(), let cached = cache.get() {
            return cached.map { CharacterEntityMapper.map(entity: $0) }
        }

        guard let networkService = networkService else {
            throw NSError(
                domain: "CharactersRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "NetworkService is nil"])
        }

        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = networkService.getCharacters()
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        continuation.resume(throwing: error)
                    }
                    cancellable = nil
                }, receiveValue: { characterEntities in
                    self.cache.save(characterEntities)
                    let characters = characterEntities.map { CharacterEntityMapper.map(entity: $0) }
                    continuation.resume(returning: characters)
                    cancellable = nil
                })
        }
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
