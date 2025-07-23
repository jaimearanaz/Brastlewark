import Testing
import Swinject

@testable import Domain

// swiftlint:disable force_cast force_unwrapping
final class DeleteActiveFilterUseCaseTests {
    var sut: DeleteActiveFilterUseCaseProtocol!
    var filterRepositoryMock: FilterRepositoryMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(DeleteActiveFilterUseCaseProtocol.self)!
        filterRepositoryMock = (container.resolve(FilterRepositoryProtocol.self) as! FilterRepositoryMock)
    }

    @Test
    func given_repositoryDeletesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        filterRepositoryMock.deleteActiveFilterError = nil

        // when
        let result = await sut.execute()

        // then
        switch result {
        case .success:
            #expect(Bool(true))
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.deleteActiveFilterCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        filterRepositoryMock.deleteActiveFilterError = FilterRepositoryError.unableToDeleteFilter

        // when
        let result = await sut.execute()

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToDeleteFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(filterRepositoryMock.deleteActiveFilterCalled))
    }
}
// swiftlint:enable force_cast force_unwrapping
