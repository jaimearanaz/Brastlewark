import Testing

@testable import Domain

struct GetActiveFilterUseCaseTests {
    @Test
    func given_repositoryReturnsFilter_when_execute_then_returnsSuccessWithFilter() async throws {
        // given
        let expectedFilter = Filter(age: 1...2, weight: 3...4, height: 5...6, friends: 7...8)
        let repositoryMock = FilterRepositoryMock()
        repositoryMock.getActiveFilterResult = expectedFilter
        let useCase = GetActiveFilterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = FilterRepositoryMock()
        repositoryMock.getActiveFilterError = TestError.someError
        let useCase = GetActiveFilterUseCase(repository: repositoryMock)

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
