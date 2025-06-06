import Testing

@testable import Domain

struct DeleteSelectedCharacterUseCaseTests {
    @Test
    func given_repository_succeeds_when_execute_then_returns_success() async throws {
        // given
        let repositoryMock = CharactersRepositoryMock()
        let useCase = DeleteSelectedCharacterUseCase(repository: repositoryMock)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success:
            #expect(Bool(true))
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_repository_throws_error_when_execute_then_returns_failure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.deleteSelectedCharacterError = TestError.someError
        let useCase = DeleteSelectedCharacterUseCase(repository: repositoryMock)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }
}
