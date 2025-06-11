import Domain
import XCTest

@testable import Data

final class CharactersRepositoryTests: XCTestCase {
    func test_given_validCache_when_getAllCharacters_then_returnsCachedCharacters() async throws {
        // given
        let cache = CacheMock()
        let entity = try loadCharacterFromJSON()
        cache.storedCharacters = [entity]
        cache.valid = true
        let repo = CharactersRepository(networkService: nil, cache: cache)

        // when
        let result = try await repo.getAllCharacters()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkSuccess_when_getAllCharacters_then_returnsNetworkCharactersAndSavesToCache() async throws {
        // given
        let cache = CacheMock()
        cache.valid = false
        let entity = try loadCharacterFromJSON()
        let network = NetworkServiceMock()
        network.result = [entity]
        let repo = CharactersRepository(networkService: network, cache: cache)

        // when
        let result = try await repo.getAllCharacters()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
        XCTAssertTrue(cache.saveCalled)
        XCTAssertEqual(cache.storedCharacters?.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkFailure_when_getAllCharacters_then_throwsError() async {
        // given
        let cache = CacheMock()
        cache.valid = false
        let network = NetworkServiceMock()
        network.error = NetworkErrors.general
        let repo = CharactersRepository(networkService: network, cache: cache)

        // when
        do {
            _ = try await repo.getAllCharacters()
            XCTFail("Should throw error")
        } catch {
            // then
            // Success: error thrown
        }
    }

    func test_given_nilNetworkService_when_getAllCharacters_then_throwsError() async {
        // given
        let cache = CacheMock()
        cache.valid = false
        let repo = CharactersRepository(networkService: nil, cache: cache)

        // when
        do {
            _ = try await repo.getAllCharacters()
            XCTFail("Should throw error")
        } catch {
            // then
            // Success: error thrown
        }
    }

    func test_when_saveSelectedCharacter_and_getSelectedCharacter_then_returnsSavedCharacter() async throws {
        // given
        let cache = CacheMock()
        let repo = CharactersRepository(networkService: nil, cache: cache)
        let character = try loadCharacterFromJSON()

        // when
        try await repo.saveSelectedCharacter(CharacterEntityMapper.map(entity: character))
        let selected = try await repo.getSelectedCharacter()

        // then
        XCTAssertEqual(selected?.id, character.id)
    }

    func test_when_saveSelectedCharacter_and_deleteSelectedCharacter_then_getSelectedCharacterReturnsNil() async throws {
        // given
        let cache = CacheMock()
        let repo = CharactersRepository(networkService: nil, cache: cache)
        let character = try loadCharacterFromJSON()

        // when
        try await repo.saveSelectedCharacter(CharacterEntityMapper.map(entity: character))
        try await repo.deleteSelectedCharacter()
        let selected = try await repo.getSelectedCharacter()

        // then
        XCTAssertNil(selected)
    }
}

private extension CharactersRepositoryTests {
    func loadCharacterFromJSON() throws -> CharacterEntity {
        let url = Bundle.module.url(forResource: "one_valid_character", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(CharacterEntity.self, from: data)
    }
}
