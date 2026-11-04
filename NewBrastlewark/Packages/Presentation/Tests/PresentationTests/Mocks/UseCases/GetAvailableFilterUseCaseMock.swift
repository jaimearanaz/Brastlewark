import Domain
import Synchronization

public final class GetAvailableFilterUseCaseMock: GetAvailableFilterUseCaseProtocol, Sendable {
    private let state: Mutex<Result<Filter, GetAvailableFilterUseCaseError>>

    public var executeResult: Result<Filter, GetAvailableFilterUseCaseError> {
        get { state.withLock { $0 } }
        set { state.withLock { $0 = newValue } }
    }

    public init(executeResult: Result<Filter, GetAvailableFilterUseCaseError> = .success(Filter())) {
        state = Mutex(executeResult)
    }

    public func execute() async -> Result<Filter, GetAvailableFilterUseCaseError> {
        executeResult
    }
}
