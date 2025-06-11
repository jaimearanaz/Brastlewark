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
        let character = try loadOneCharacterFromJSON()
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
        let character = try loadOneCharacterFromJSON()
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
