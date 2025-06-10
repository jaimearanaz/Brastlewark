import Testing

@testable import Domain

struct SaveActiveFilterUseCaseTests {
    @Test
    func given_repositorySucceeds_when_execute_then_returnsSuccess() async throws {
        // given
        let repositoryMock = FilterRepositoryMock()
        let filter = Filter(age: 1...2, weight: 3...4, height: 5...6, friends: 7...8)
        let useCase = SaveActiveFilterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(filter: filter))

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
        let repositoryMock = FilterRepositoryMock()
        repositoryMock.saveActiveFilterError = TestError.someError
        let filter = Filter(age: 1...2, weight: 3...4, height: 5...6, friends: 7...8)
        let useCase = SaveActiveFilterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(filter: filter))

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }
}
