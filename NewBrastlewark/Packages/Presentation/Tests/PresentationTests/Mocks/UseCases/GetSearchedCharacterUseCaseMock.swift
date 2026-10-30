import Foundation
import Domain

public final class GetSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseProtocol, @unchecked Sendable {
    private let lock = NSLock()
    private var _executeResult: Result<[Character], CharactersRepositoryError> = .success([])
    private var _suspendFirstExecution = false
    private var _executionCount = 0
    private var _cancellationCount = 0
    
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

    public var suspendFirstExecution: Bool {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _suspendFirstExecution
        }
        set {
            lock.lock()
            _suspendFirstExecution = newValue
            lock.unlock()
        }
    }

    public var executionCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _executionCount
    }

    public var cancellationCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _cancellationCount
    }

    public init(executeResult: Result<[Character], CharactersRepositoryError> = .success([])) {
        self._executeResult = executeResult
    }

    public func execute(params: GetSearchedCharacterUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        let shouldSuspend = registerExecution()

        if shouldSuspend {
            do {
                try await Task.sleep(for: .seconds(60))
            } catch {
                registerCancellation()
                return .failure(.unableToFetchCharacters)
            }
        }

        return executeResult
    }

    private func registerExecution() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        _executionCount += 1
        return _suspendFirstExecution && _executionCount == 1
    }

    private func registerCancellation() {
        lock.lock()
        _cancellationCount += 1
        lock.unlock()
    }
}
