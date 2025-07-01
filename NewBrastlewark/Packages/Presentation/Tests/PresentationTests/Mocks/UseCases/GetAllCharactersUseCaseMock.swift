import Foundation
import Domain

public final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol, @unchecked Sendable {
    private let queue = DispatchQueue(label: "GetAllCharactersUseCaseMock.queue")
    private var _executeResult: Result<[Character], CharactersRepositoryError> = .success([])
    private var _capturedParams: GetAllCharactersUseCaseParams?

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

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        self._executeResult = executeResult
    }

    public func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        queue.sync {
            _capturedParams = params
        }
        return executeResult
    }
}
