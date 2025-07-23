import Foundation
import Domain

public final class GetActiveFilterUseCaseMock: GetActiveFilterUseCaseProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var _executeResult: Result<Filter?, FilterRepositoryError> = .success(nil)
    
    public var executeResult: Result<Filter?, FilterRepositoryError> {
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

    public init(executeResult: Result<Filter?, FilterRepositoryError> = .success(nil)) {
        self._executeResult = executeResult
    }

    public func execute() async -> Result<Filter?, FilterRepositoryError> {
        return executeResult
    }
}
