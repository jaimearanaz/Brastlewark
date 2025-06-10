import Testing

@testable import Domain

struct DeleteSelectedCharacterUseCaseTests {
    @Test
    func given_repositorySucceeds_when_execute_then_returnsSuccess() async throws {
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
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
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
