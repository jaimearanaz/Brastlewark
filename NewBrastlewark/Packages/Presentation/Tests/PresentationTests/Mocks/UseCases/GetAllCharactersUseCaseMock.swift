import Foundation
import Domain

public final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol, @unchecked Sendable {
    private let queue = DispatchQueue(label: "GetAllCharactersUseCaseMock.queue")
    private var _executeResult: Result<[Character], CharactersRepositoryError> = .success([])
    private var _capturedParams: GetAllCharactersUseCaseParams?
    private var _suspendFirstExecution = false
    private var _executionCount = 0
    private var _cancellationCount = 0

    public var executeResult: Result<[Character], CharactersRepositoryError> {
        get {
            queue.sync { _executeResult }
        }
        set {
            queue.sync { _executeResult = newValue }
        }
    }

    public var capturedParams: GetAllCharactersUseCaseParams? {
        queue.sync { _capturedParams }
    }

    public var wasForceUpdateCalled: Bool {
        capturedParams?.forceUpdate == true
    }

    public var suspendFirstExecution: Bool {
        get { queue.sync { _suspendFirstExecution } }
        set { queue.sync { _suspendFirstExecution = newValue } }
    }

    public var executionCount: Int {
        queue.sync { _executionCount }
    }

    public var cancellationCount: Int {
        queue.sync { _cancellationCount }
    }

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        self._executeResult = executeResult
    }

    public func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        let shouldSuspend = queue.sync {
            _capturedParams = params
            _executionCount += 1
            return _suspendFirstExecution && _executionCount == 1
        }

        if shouldSuspend {
            do {
                try await Task.sleep(for: .seconds(60))
            } catch {
                queue.sync { _cancellationCount += 1 }
                return .failure(.unableToFetchCharacters)
            }
        }

        return executeResult
    }
}
