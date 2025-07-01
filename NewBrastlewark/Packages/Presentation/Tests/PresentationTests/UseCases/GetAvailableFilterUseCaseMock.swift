import Domain
import Foundation

public final class GetAvailableFilterUseCaseMock: GetAvailableFilterUseCaseProtocol, @unchecked Sendable {
    private let queue = DispatchQueue(label: "GetAvailableFilterUseCaseMock.queue")
    private var _executeResult: Result<Filter, GetAvailableFilterUseCaseError> = .success(Filter())

    public var executeResult: Result<Filter, GetAvailableFilterUseCaseError> {
        get {
            queue.sync { _executeResult }
        }
        set {
            queue.sync { _executeResult = newValue }
        }
    }

    public init(executeResult: Result<Filter, GetAvailableFilterUseCaseError> = .success(Filter())) {
        self._executeResult = executeResult
    }

    public func execute() async -> Result<Filter, GetAvailableFilterUseCaseError> {
        return executeResult
    }
}
