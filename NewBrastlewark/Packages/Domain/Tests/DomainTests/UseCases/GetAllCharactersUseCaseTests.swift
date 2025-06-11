import Foundation
import Testing

@testable import Domain

struct GetAllCharactersUseCaseTests {
    @Test
    func given_repositoryReturnsCharacters_when_execute_then_returnsSuccessWithCharacters() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let expectedCharacters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = expectedCharacters
        repository.getAllCharactersError = nil
        let useCase = GetAllCharactersUseCase(repository: repository)
        let params = GetAllCharactersUseCaseParams(forceUpdate: false)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success(let characters):
            #expect(characters == expectedCharacters)
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
        let useCase = GetAllCharactersUseCase(repository: repository)
        let params = GetAllCharactersUseCaseParams(forceUpdate: true)
        
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

private extension GetAllCharactersUseCaseTests {
    func loadCharactersFromJSON() throws -> [Character] {
        let url = Bundle.module.url(forResource: "characters", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Character].self, from: data)
    }
}
