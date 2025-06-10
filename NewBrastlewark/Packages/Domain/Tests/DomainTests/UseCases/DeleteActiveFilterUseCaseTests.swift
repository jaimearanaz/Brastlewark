import Testing
@testable import Domain

struct DeleteActiveFilterUseCaseTests {
    @Test
    func given_repositoryDeletesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        let repository = FilterRepositoryMock()
        repository.deleteActiveFilterError = nil
        let useCase = DeleteActiveFilterUseCase(repository: repository)

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.deleteActiveFilterCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = FilterRepositoryMock()
        repository.deleteActiveFilterError = FilterRepositoryError.unableToDeleteFilter
        let useCase = DeleteActiveFilterUseCase(repository: repository)

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToDeleteFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.deleteActiveFilterCalled))
    }
}
