import Foundation
import Testing

@testable import Domain

struct GetSearchedCharacterUseCaseTests {
    @Test
    func given_repositoryReturnsCharacters_when_executeWithMatchingName_then_returnsCharactersWithName() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "Fizwood")

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            let expected = characters.filter { $0.name.localizedCaseInsensitiveContains("Fizwood") }
            #expect(filtered == expected)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithMatchingProfession_then_returnsCharactersWithProfession() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "Tinker")

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            let expected = characters.filter { $0.professions.contains(where: { $0.localizedCaseInsensitiveContains("Tinker") }) }
            #expect(filtered == expected)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithEmptySearchText_then_returnsAllCharacters() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "")

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(filtered == characters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "Alice")

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }
}

private extension GetSearchedCharacterUseCaseTests {
    func loadCharactersFromJSON() throws -> [Character] {
        let url = Bundle.module.url(forResource: "characters", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Character].self, from: data)
    }
}
