import Domain
import Synchronization

public final class GetFilteredCharactersUseCaseMock: GetFilteredCharactersUseCaseProtocol, Sendable {
    private let state: Mutex<Result<[Character], CharactersRepositoryError>>

    public var executeResult: Result<[Character], CharactersRepositoryError> {
        get { state.withLock { $0 } }
        set { state.withLock { $0 = newValue } }
    }

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        state = Mutex(executeResult)
    }

    public func execute(
        params: GetFilteredCharactersUseCaseParams
    ) async -> Result<[Character], CharactersRepositoryError> {
        executeResult
    }
}
