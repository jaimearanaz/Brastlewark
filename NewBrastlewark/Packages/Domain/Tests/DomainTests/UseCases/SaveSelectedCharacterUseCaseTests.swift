import Foundation
import Testing

@testable import Domain

struct SaveSelectedCharacterUseCaseTests {
    @Test
    func given_repositorySavesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.saveSelectedCharacterError = nil
        let useCase = SaveSelectedCharacterUseCase(repository: repository)
        let character = try loadCharacterFromJSON()
        let params = SaveSelectedCharacterUseCaseParams(character: character)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveSelectedCharacterCalled))
        #expect(repository.savedCharacter == character)
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.saveSelectedCharacterError = CharactersRepositoryError.unableToSaveSelectedCharacter
        let useCase = SaveSelectedCharacterUseCase(repository: repository)
        let character = try loadCharacterFromJSON()
        let params = SaveSelectedCharacterUseCaseParams(character: character)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToSaveSelectedCharacter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveSelectedCharacterCalled))
    }
}

private extension SaveSelectedCharacterUseCaseTests {
    func loadCharacterFromJSON() throws -> Character {
        let url = Bundle.module.url(forResource: "one_valid_character", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Character.self, from: data)
    }
}
