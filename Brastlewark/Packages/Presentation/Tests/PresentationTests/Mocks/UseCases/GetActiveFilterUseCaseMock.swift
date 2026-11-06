import Domain
import Synchronization

public final class GetActiveFilterUseCaseMock: GetActiveFilterUseCaseProtocol, Sendable {
    private let state: Mutex<Result<Filter?, FilterRepositoryError>>

    public var executeResult: Result<Filter?, FilterRepositoryError> {
        get { state.withLock { $0 } }
        set { state.withLock { $0 = newValue } }
    }

    public init(executeResult: Result<Filter?, FilterRepositoryError> = .success(nil)) {
        state = Mutex(executeResult)
    }

    public func execute() async -> Result<Filter?, FilterRepositoryError> {
        executeResult
    }
}
