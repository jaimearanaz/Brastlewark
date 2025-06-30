import Foundation
import Domain

public final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var _executeResult: Result<[Character], CharactersRepositoryError> = .success([])
    
    public var executeResult: Result<[Character], CharactersRepositoryError> {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _executeResult
        }
        set {
            lock.lock()
            _executeResult = newValue
            lock.unlock()
        }
    }

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        self._executeResult = executeResult
    }

    public func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        return executeResult
    }
}