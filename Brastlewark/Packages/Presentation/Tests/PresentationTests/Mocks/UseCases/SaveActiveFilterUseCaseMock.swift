import Domain
import Synchronization

public final class SaveActiveFilterUseCaseMock: SaveActiveFilterUseCaseProtocol, Sendable {
    private struct State: Sendable {
        var executeResult: Result<Void, FilterRepositoryError>
        var capturedParams: SaveActiveFilterUseCaseParams?
    }

    private let state: Mutex<State>

    public var executeResult: Result<Void, FilterRepositoryError> {
        get { state.withLock { $0.executeResult } }
        set { state.withLock { $0.executeResult = newValue } }
    }

    public var capturedParams: SaveActiveFilterUseCaseParams? {
        state.withLock { $0.capturedParams }
    }

    public init(executeResult: Result<Void, FilterRepositoryError> = .success(())) {
        state = Mutex(State(executeResult: executeResult, capturedParams: nil))
    }

    public func execute(
        params: SaveActiveFilterUseCaseParams
    ) async -> Result<Void, FilterRepositoryError> {
        state.withLock {
            $0.capturedParams = params
            return $0.executeResult
        }
    }
}
