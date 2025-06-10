import XCTest
@testable import Data
import Domain

final class CharactersRepositoryTests: XCTestCase {
    func test_given_validCache_when_getAllCharacters_then_returnsCachedCharacters() async throws {
        let cache = CacheMock()
        let entity = CharacterEntity(id: 1, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])
        cache.storedCharacters = [entity]
        cache.valid = true
        let repo = CharactersRepository(networkService: nil, cache: cache)
        let result = try await repo.getAllCharacters()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkSuccess_when_getAllCharacters_then_returnsNetworkCharactersAndSavesToCache() async throws {
        let cache = CacheMock()
        cache.valid = false
        let entity = CharacterEntity(id: 2, name: "Net", thumbnail: "", age: 20, weight: 40, height: 60, hairColor: "", professions: [], friends: [])
        let network = NetworkServiceMock()
        network.result = [entity]
        let repo = CharactersRepository(networkService: network, cache: cache)
        let result = try await repo.getAllCharacters()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
        XCTAssertTrue(cache.saveCalled)
        XCTAssertEqual(cache.storedCharacters?.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkFailure_when_getAllCharacters_then_throwsError() async {
        let cache = CacheMock()
        cache.valid = false
        let network = NetworkServiceMock()
        network.error = NetworkErrors.general
        let repo = CharactersRepository(networkService: network, cache: cache)
        do {
            _ = try await repo.getAllCharacters()
            XCTFail("Should throw error")
        } catch {
            // Success: error thrown
        }
    }

    func test_given_nilNetworkService_when_getAllCharacters_then_throwsError() async {
        let cache = CacheMock()
        cache.valid = false
        let repo = CharactersRepository(networkService: nil, cache: cache)
        do {
            _ = try await repo.getAllCharacters()
            XCTFail("Should throw error")
        } catch {
            // Success: error thrown
        }
    }

    func test_when_saveSelectedCharacter_and_getSelectedCharacter_then_returnsSavedCharacter() async throws {
        let cache = CacheMock()
        let repo = CharactersRepository(networkService: nil, cache: cache)
        let character = Character(id: 1, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])
        try await repo.saveSelectedCharacter(character)
        let selected = try await repo.getSelectedCharacter()
        XCTAssertEqual(selected?.id, character.id)
    }

    func test_when_saveSelectedCharacter_and_deleteSelectedCharacter_then_getSelectedCharacterReturnsNil() async throws {
        let cache = CacheMock()
        let repo = CharactersRepository(networkService: nil, cache: cache)
        let character = Character(id: 1, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])
        try await repo.saveSelectedCharacter(character)
        try await repo.deleteSelectedCharacter()
        let selected = try await repo.getSelectedCharacter()
        XCTAssertNil(selected)
    }
}
