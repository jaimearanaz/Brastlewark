import Domain
import Synchronization

public final class GetSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseProtocol, Sendable {
    private struct State: Sendable {
        var executeResult: Result<[Character], CharactersRepositoryError>
        var suspendFirstExecution = false
        var executionCount = 0
        var cancellationCount = 0
    }

    private let state: Mutex<State>

    public var executeResult: Result<[Character], CharactersRepositoryError> {
        get { state.withLock { $0.executeResult } }
        set { state.withLock { $0.executeResult = newValue } }
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
        state = Mutex(State(executeResult: executeResult))
    }

    public func execute(
        params: GetSearchedCharacterUseCaseParams
    ) async -> Result<[Character], CharactersRepositoryError> {
        let shouldSuspend = state.withLock {
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
