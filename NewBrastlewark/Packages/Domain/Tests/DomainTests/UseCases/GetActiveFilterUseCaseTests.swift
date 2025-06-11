import Testing
@testable import Domain

struct GetActiveFilterUseCaseTests {
    @Test
    func given_repositoryReturnsFilter_when_execute_then_returnsSuccessWithFilter() async throws {
        // given
        let repository = FilterRepositoryMock()
        let expectedFilter = Filter(
            age: 10...20,
            weight: 30...50,
            height: 100...150,
            hairColor: ["red"],
            profession: ["baker"],
            friends: 1...5)
        repository.getActiveFilterResult = expectedFilter
        repository.getActiveFilterError = nil
        let useCase = GetActiveFilterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getActiveFilterCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = FilterRepositoryMock()
        repository.getActiveFilterError = FilterRepositoryError.unableToFetchFilter
        let useCase = GetActiveFilterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getActiveFilterCalled))
    }
}
