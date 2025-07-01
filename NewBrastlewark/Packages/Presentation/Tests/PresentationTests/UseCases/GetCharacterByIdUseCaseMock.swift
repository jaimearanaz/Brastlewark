import Domain
import Foundation

public final class GetCharacterByIdUseCaseMock: GetCharacterByIdUseCaseProtocol, @unchecked Sendable {
    private let queue = DispatchQueue(label: "GetCharacterByIdUseCaseMock.queue")
    private var _executeResult: Result<Character?, CharactersRepositoryError> = .success(nil)
    private var _capturedParams: GetCharacterByIdUseCaseParams?
    
    public var executeResult: Result<Character?, CharactersRepositoryError> {
        get {
            queue.sync { _executeResult }
        }
        set {
            queue.sync { _executeResult = newValue }
        }
    }
    
    public var capturedParams: GetCharacterByIdUseCaseParams? {
        queue.sync { _capturedParams }
    }
    
    public var capturedId: Int? {
        capturedParams?.id
    }
    
    public init(executeResult: Result<Character?, CharactersRepositoryError> = .success(nil)) {
        self._executeResult = executeResult
    }
    
    public func execute(params: GetCharacterByIdUseCaseParams) async -> Result<Character?, CharactersRepositoryError> {
        queue.sync { _capturedParams = params }
        return executeResult
    }
}
