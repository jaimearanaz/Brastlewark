import Domain
import Synchronization

public final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol, Sendable {
    private struct State: Sendable {
        var executeResult: Result<[Character], CharactersRepositoryError>
        var capturedParams: GetAllCharactersUseCaseParams?
        var suspendFirstExecution = false
        var executionCount = 0
        var cancellationCount = 0
    }

    private let state: Mutex<State>

    public var executeResult: Result<[Character], CharactersRepositoryError> {
        get { state.withLock { $0.executeResult } }
        set { state.withLock { $0.executeResult = newValue } }
    }

    public var capturedParams: GetAllCharactersUseCaseParams? {
        state.withLock { $0.capturedParams }
    }

    public var wasForceUpdateCalled: Bool {
        capturedParams?.forceUpdate == true
    }

    public var suspendFirstExecution: Bool {
        get { state.withLock { $0.suspendFirstExecution } }
        set { state.withLock { $0.suspendFirstExecution = newValue } }
    }

    public var executionCount: Int {
        state.withLock { $0.executionCount }
    }

    public var cancellationCount: Int {
        state.withLock { $0.cancellationCount }
    }

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        state = Mutex(State(executeResult: executeResult, capturedParams: nil))
    }

    public func execute(
        params: GetAllCharactersUseCaseParams
    ) async -> Result<[Character], CharactersRepositoryError> {
        let shouldSuspend = state.withLock {
            $0.capturedParams = params
            $0.executionCount += 1
            return $0.suspendFirstExecution && $0.executionCount == 1
        }

        if shouldSuspend {
            do {
                try await Task.sleep(for: .seconds(60))
            } catch {
                state.withLock { $0.cancellationCount += 1 }
                return .failure(.unableToFetchCharacters)
            }
        }

        return executeResult
    }
}
