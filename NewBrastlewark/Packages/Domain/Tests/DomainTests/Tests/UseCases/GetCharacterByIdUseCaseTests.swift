import Foundation
import Testing
import Swinject

@testable import Domain

// swiftlint:disable force_cast force_unwrapping
final class GetCharacterByIdUseCaseTests {
    var sut: GetCharacterByIdUseCaseProtocol!
    var charactersRepositoryMock: CharactersRepositoryMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetCharacterByIdUseCaseProtocol.self)!
        charactersRepositoryMock = (container.resolve(CharactersRepositoryProtocol.self) as! CharactersRepositoryMock)
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithExistingId_then_returnsCharacter() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let existingId = characters.first!.id
        let params = GetCharacterByIdUseCaseParams(id: existingId)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let character):
            #expect(character?.id == existingId)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithNonExistingId_then_returnsNil() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let nonExistingId = (characters.map { $0.id }.max() ?? 0) + 1
        let params = GetCharacterByIdUseCaseParams(id: nonExistingId)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let character):
            #expect(character == nil)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let params = GetCharacterByIdUseCaseParams(id: 1)

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
