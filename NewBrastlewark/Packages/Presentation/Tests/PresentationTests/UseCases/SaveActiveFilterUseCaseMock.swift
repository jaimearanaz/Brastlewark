import Domain
import Foundation

public final class SaveActiveFilterUseCaseMock: SaveActiveFilterUseCaseProtocol, @unchecked Sendable {
    private let queue = DispatchQueue(label: "SaveActiveFilterUseCaseMock.queue")
    private var _executeResult: Result<Void, FilterRepositoryError> = .success(())
    private var _capturedParams: SaveActiveFilterUseCaseParams?

    public var executeResult: Result<Void, FilterRepositoryError> {
        get {
            queue.sync { _executeResult }
        }
        set {
            queue.sync { _executeResult = newValue }
        }
    }

    public var capturedParams: SaveActiveFilterUseCaseParams? {
        queue.sync { _capturedParams }
    }

    public init(executeResult: Result<Void, FilterRepositoryError> = .success(())) {
        self._executeResult = executeResult
    }

    public func execute(params: SaveActiveFilterUseCaseParams) async -> Result<Void, FilterRepositoryError> {
        queue.sync { _capturedParams = params }
        return executeResult
    }
}
