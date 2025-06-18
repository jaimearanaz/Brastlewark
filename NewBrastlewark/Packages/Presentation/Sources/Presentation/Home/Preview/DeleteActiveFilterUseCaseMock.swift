import Foundation
import Domain

public final class DeleteActiveFilterUseCaseMock: DeleteActiveFilterUseCaseProtocol {
    public init() {}
    
    public func execute() async -> Result<Void, FilterRepositoryError> {
        .success(())
    }
}