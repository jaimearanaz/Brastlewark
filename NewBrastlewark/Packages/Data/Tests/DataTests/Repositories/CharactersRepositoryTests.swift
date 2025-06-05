import Combine
import Domain
import Foundation
import Testing

@testable import Data

final class CharactersRepositoryTests {
    @Test
    func given_validCache_when_getAllCharacters_then_returnsCachedCharacters() async throws {
        let cache = MockCache()
        let entity = CharacterEntity.mock(id: 1, name: "Cached")
        cache.characters = [entity]
        cache.valid = true
        let repo = CharactersRepository(networkService: MockNetworkService(), cache: cache)
        let result = try await repo.getAllCharacters()
        #expect(result.count == 1)
        #expect(result.first?.id == 1)
        #expect(result.first?.name == "Cached")
    }

    @Test
    func given_invalidCache_and_networkSuccess_when_getAllCharacters_then_returnsNetworkCharactersAndSavesToCache() async throws {
        let cache = MockCache()
        cache.valid = false
        let entity = CharacterEntity.mock(id: 2, name: "Network")
        let network = MockNetworkService()
        network.result = .success([entity])
        let repo = CharactersRepository(networkService: network, cache: cache)
        let result = try await repo.getAllCharacters()
        #expect(result.count == 1)
        #expect(result.first?.id == 2)
        #expect(result.first?.name == "Network")
        #expect(cache.characters?.first?.id == 2)
    }

    @Test
    func given_invalidCache_and_networkFailure_when_getAllCharacters_then_throwsError() async {
        let cache = MockCache()
        cache.valid = false
        let network = MockNetworkService()
        network.result = .failure(NetworkErrors.noNetwork)
        let repo = CharactersRepository(networkService: network, cache: cache)
        do {
            _ = try await repo.getAllCharacters()
            #expect(Bool(false))
        } catch {
            if case .noNetwork? = error as? NetworkErrors {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
    }

    @Test
    func given_nilNetworkService_when_getAllCharacters_then_throwsError() async {
        let cache = MockCache()
        let repo = CharactersRepository(networkService: nil, cache: cache)
        do {
            _ = try await repo.getAllCharacters()
            #expect(Bool(false))
        } catch {
            #expect((error as NSError).domain == "CharactersRepository")
        }
    }

    @Test
    func when_saveSelectedCharacter_and_getSelectedCharacter_then_returnsSavedCharacter() async throws {
        let cache = MockCache()
        let repo = CharactersRepository(networkService: MockNetworkService(), cache: cache)
        let character = Character(id: 1, name: "Test", thumbnail: "url", age: 10, weight: 20, height: 30, hairColor: "Brown", professions: [], friends: [])
        try await repo.saveSelectedCharacter(character)
        let selected = try await repo.getSelectedCharacter()
        #expect(selected?.id == 1)
        #expect(selected?.name == "Test")
    }

    @Test
    func when_saveSelectedCharacter_and_deleteSelectedCharacter_then_getSelectedCharacterReturnsNil() async throws {
        let cache = MockCache()
        let repo = CharactersRepository(networkService: MockNetworkService(), cache: cache)
        let character = Character(id: 1, name: "Test", thumbnail: "url", age: 10, weight: 20, height: 30, hairColor: "Brown", professions: [], friends: [])
        try await repo.saveSelectedCharacter(character)
        try await repo.deleteSelectedCharacter()
        let selected = try await repo.getSelectedCharacter()
        #expect(selected == nil)
    }
}
