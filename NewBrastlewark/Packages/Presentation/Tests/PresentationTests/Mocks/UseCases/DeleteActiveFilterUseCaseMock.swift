import Foundation
import Domain

public final class DeleteActiveFilterUseCaseMock: DeleteActiveFilterUseCaseProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var _executeResult: Result<Void, FilterRepositoryError> = .success(())
    
    public var executeResult: Result<Void, FilterRepositoryError> {
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

    public init(executeResult: Result<Void, FilterRepositoryError> = .success(())) {
        self._executeResult = executeResult
    }

    public func execute() async -> Result<Void, FilterRepositoryError> {
        return executeResult
    }
}
