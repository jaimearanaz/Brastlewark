import Domain
import Synchronization

public final class GetCharacterByIdUseCaseMock: GetCharacterByIdUseCaseProtocol, Sendable {
    private struct State: Sendable {
        var executeResult: Result<Character?, CharactersRepositoryError>
        var capturedParams: GetCharacterByIdUseCaseParams?
    }

    private let state: Mutex<State>

    public var executeResult: Result<Character?, CharactersRepositoryError> {
        get { state.withLock { $0.executeResult } }
        set { state.withLock { $0.executeResult = newValue } }
    }

    public var capturedParams: GetCharacterByIdUseCaseParams? {
        state.withLock { $0.capturedParams }
    }

    public var capturedId: Int? {
        capturedParams?.id
    }

    public init(executeResult: Result<Character?, CharactersRepositoryError> = .success(nil)) {
        state = Mutex(State(executeResult: executeResult, capturedParams: nil))
    }

    public func execute(
        params: GetCharacterByIdUseCaseParams
    ) async -> Result<Character?, CharactersRepositoryError> {
        state.withLock {
            $0.capturedParams = params
            return $0.executeResult
        }
    }
}
