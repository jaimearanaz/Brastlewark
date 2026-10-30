import Domain
import XCTest

@testable import Data

// swiftlint:disable force_cast force_unwrapping
final class CharactersRepositoryTests: XCTestCase {
    private var sut: CharactersRepositoryProtocol!
    private var cacheMock: CacheMock!
    private var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(CharactersRepositoryProtocol.self)! as! CharactersRepository
        cacheMock = (container.resolve(CharactersCacheProtocol.self) as! CacheMock)
        networkServiceMock = (container.resolve(NetworkServiceProtocol.self) as! NetworkServiceMock)
    }

    func test_given_validCache_when_getAllCharacters_then_returnsCachedCharacters() async throws {
        // given
        let entity = try loadOneCharacterFromJSON()
        cacheMock.storedCharacters = [entity]
        cacheMock.valid = true

        // when
        let result = try await sut.getAllCharacters(forceUpdate: false)

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkSuccess_when_getAllCharacters_then_returnsNetworkCharactersAndSavesToCache() async throws {
        // given
        let entity = try loadOneCharacterFromJSON()
        networkServiceMock.result = [entity]
        cacheMock.valid = false

        // when
        let result = try await sut.getAllCharacters(forceUpdate: false)

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, entity.id)
        XCTAssertTrue(cacheMock.saveCalled)
        XCTAssertEqual(cacheMock.storedCharacters?.first?.id, entity.id)
    }

    func test_given_invalidCache_and_networkFailure_when_getAllCharacters_then_throwsUnableToFetchCharacters() async {
        // given
        cacheMock.valid = false
        networkServiceMock.error = NetworkErrors.general

        // when
        do {
            _ = try await sut.getAllCharacters(forceUpdate: false)
            XCTFail("Should throw error")
        } catch let error as CharactersRepositoryError {
            // then
            guard case .unableToFetchCharacters = error else {
                return XCTFail("Expected unableToFetchCharacters, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_invalidCache_and_noNetwork_when_getAllCharacters_then_throwsNoInternetConnection() async {
        // given
        cacheMock.valid = false
        networkServiceMock.error = NetworkErrors.noNetwork

        // when
        do {
            _ = try await sut.getAllCharacters(forceUpdate: false)
            XCTFail("Should throw error")
        } catch let error as CharactersRepositoryError {
            // then
            guard case .noInternetConnection = error else {
                return XCTFail("Expected noInternetConnection, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_nilNetworkService_when_getAllCharacters_then_throwsError() async {
        // given
        networkServiceMock = nil
        cacheMock.valid = false

        // when
        do {
            _ = try await sut.getAllCharacters(forceUpdate: false)
            XCTFail("Should throw error")
        } catch let error as CharactersRepositoryError {
            // then
            guard case .noInternetConnection = error else {
                return XCTFail("Expected noInternetConnection, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
// swiftlint:enable force_cast force_unwrapping
