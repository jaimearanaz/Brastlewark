import Foundation
import Testing
import Swinject

@testable import Domain

// swiftlint:disable force_cast force_unwrapping
final class GetAllCharactersUseCaseTests {
    var sut: GetAllCharactersUseCaseProtocol!
    var charactersRepositoryMock: CharactersRepositoryMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetAllCharactersUseCaseProtocol.self)!
        charactersRepositoryMock = (container.resolve(CharactersRepositoryProtocol.self) as! CharactersRepositoryMock)
    }

    @Test
    func given_repositoryReturnsCharacters_when_execute_then_returnsSuccessWithCharacters() async throws {
        // given
        let expectedCharacters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = expectedCharacters
        charactersRepositoryMock.getAllCharactersError = nil
        let params = GetAllCharactersUseCaseParams(forceUpdate: false)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let characters):
            #expect(characters == expectedCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let params = GetAllCharactersUseCaseParams(forceUpdate: true)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }
}
// swiftlint:enable force_cast force_unwrapping
