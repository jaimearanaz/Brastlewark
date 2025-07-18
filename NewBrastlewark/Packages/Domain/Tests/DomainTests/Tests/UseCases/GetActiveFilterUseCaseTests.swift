import Testing
import Swinject

@testable import Domain

final class GetActiveFilterUseCaseTests {
    var sut: GetActiveFilterUseCaseProtocol!
    var filterRepositoryMock: FilterRepositoryMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetActiveFilterUseCaseProtocol.self)!
        filterRepositoryMock = (container.resolve(FilterRepositoryProtocol.self) as! FilterRepositoryMock)
    }

    @Test
    func given_repositoryReturnsFilter_when_execute_then_returnsSuccessWithFilter() async throws {
        // given
        let expectedFilter = Filter(
            age: 10...20,
            weight: 30...50,
            height: 100...150,
            hairColor: ["red"],
            profession: ["baker"],
            friends: 1...5)
        filterRepositoryMock.getActiveFilterResult = expectedFilter
        filterRepositoryMock.getActiveFilterError = nil

        // when
        let result = await sut.execute()

        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.getActiveFilterCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        filterRepositoryMock.getActiveFilterError = FilterRepositoryError.unableToFetchFilter

        // when
        let result = await sut.execute()

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.getActiveFilterCalled))
    }
}
