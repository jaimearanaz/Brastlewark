import Foundation
import Testing
import Swinject

@testable import Domain

// swiftlint:disable force_cast force_unwrapping
final class GetSearchedCharacterUseCaseTests {
    var sut: GetSearchedCharacterUseCaseProtocol!
    var charactersRepositoryMock: CharactersRepositoryMock!
    
    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetSearchedCharacterUseCaseProtocol.self)!
        charactersRepositoryMock = (container.resolve(CharactersRepositoryProtocol.self) as! CharactersRepositoryMock)
    }
    
    @Test
    func given_repositoryReturnsCharacters_when_executeWithMatchingName_then_returnsCharactersWithName() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let params = GetSearchedCharacterUseCaseParams(searchText: "Fizwood")

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            let expected = characters.filter { $0.name.localizedCaseInsensitiveContains("Fizwood") }
            #expect(filtered == expected)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithMatchingProfession_then_returnsCharactersWithProfession() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let params = GetSearchedCharacterUseCaseParams(searchText: "Tinker")

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            let expected = characters.filter { $0.professions.contains(where: { $0.localizedCaseInsensitiveContains("Tinker") }) }
            #expect(filtered == expected)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithEmptySearchText_then_returnsAllCharacters() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let params = GetSearchedCharacterUseCaseParams(searchText: "")

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(filtered == characters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let params = GetSearchedCharacterUseCaseParams(searchText: "Alice")

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
