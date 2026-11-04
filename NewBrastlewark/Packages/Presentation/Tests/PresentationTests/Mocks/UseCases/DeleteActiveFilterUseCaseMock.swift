import Domain
import Synchronization

public final class DeleteActiveFilterUseCaseMock: DeleteActiveFilterUseCaseProtocol, Sendable {
    private let state: Mutex<Result<Void, FilterRepositoryError>>

    public var executeResult: Result<Void, FilterRepositoryError> {
        get { state.withLock { $0 } }
        set { state.withLock { $0 = newValue } }
    }

    public init(executeResult: Result<Void, FilterRepositoryError> = .success(())) {
        state = Mutex(executeResult)
    }

    public func execute() async -> Result<Void, FilterRepositoryError> {
        executeResult
    }
}
