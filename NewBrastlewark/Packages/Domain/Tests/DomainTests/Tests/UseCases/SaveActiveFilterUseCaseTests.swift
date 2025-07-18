import Testing
import Swinject

@testable import Domain

final class SaveActiveFilterUseCaseTests {
    var sut: SaveActiveFilterUseCaseProtocol!
    var filterRepositoryMock: FilterRepositoryMock!
    
    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(SaveActiveFilterUseCaseProtocol.self)!
        filterRepositoryMock = (container.resolve(FilterRepositoryProtocol.self) as! FilterRepositoryMock)
    }
    
    @Test
    func given_repositorySavesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        filterRepositoryMock.saveActiveFilterError = nil
        let filter = Filter(age: 10...20, weight: 30...50, height: 100...150, hairColor: ["red"], profession: ["baker"], friends: 1...5)
        let params = SaveActiveFilterUseCaseParams(filter: filter)
        
        // when
        let result = await sut.execute(params: params)
        
        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.saveActiveFilterCalled))
        #expect(filterRepositoryMock.savedActiveFilter == filter)
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        filterRepositoryMock.saveActiveFilterError = FilterRepositoryError.unableToSaveFilter
        let filter = Filter(age: 10...20, weight: 30...50, height: 100...150, hairColor: ["red"], profession: ["baker"], friends: 1...5)
        let params = SaveActiveFilterUseCaseParams(filter: filter)
        
        // when
        let result = await sut.execute(params: params)
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToSaveFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.saveActiveFilterCalled))
    }
}
