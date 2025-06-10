import Testing
@testable import Domain

struct DeleteSelectedCharacterUseCaseTests {
    @Test
    static func given_repositoryDeletesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.deleteSelectedCharacterError = nil
        let useCase = DeleteSelectedCharacterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.deleteSelectedCharacterCalled))
    }

    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.deleteSelectedCharacterError = CharactersRepositoryError.unableToDeleteSelectedCharacter
        let useCase = DeleteSelectedCharacterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToDeleteSelectedCharacter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.deleteSelectedCharacterCalled))
    }
}
