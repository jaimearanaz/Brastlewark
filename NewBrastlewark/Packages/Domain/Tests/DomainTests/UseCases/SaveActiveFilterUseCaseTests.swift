import Testing
@testable import Domain

struct SaveActiveFilterUseCaseTests {
    @Test
    static func given_repositorySavesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        let repository = FilterRepositoryMock()
        repository.saveActiveFilterError = nil
        let useCase = SaveActiveFilterUseCase(repository: repository)
        let filter = Filter(age: 10...20, weight: 30...50, height: 100...150, hairColor: ["red"], profession: ["baker"], friends: 1...5)
        let params = SaveActiveFilterUseCaseParams(filter: filter)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveActiveFilterCalled))
        #expect(repository.savedActiveFilter == filter)
    }

    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = FilterRepositoryMock()
        repository.saveActiveFilterError = FilterRepositoryError.unableToSaveFilter
        let useCase = SaveActiveFilterUseCase(repository: repository)
        let filter = Filter(age: 10...20, weight: 30...50, height: 100...150, hairColor: ["red"], profession: ["baker"], friends: 1...5)
        let params = SaveActiveFilterUseCaseParams(filter: filter)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToSaveFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveActiveFilterCalled))
    }
}
