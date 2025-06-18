import Foundation
import Domain

public final class GetActiveFilterUseCaseMock: GetActiveFilterUseCaseProtocol {
    public init() {}
    
    public func execute() async -> Result<Filter?, FilterRepositoryError> {
        .success(
            .init(
                age: 0...100,
                weight: 0...200,
                height: 0...300,
                friends: 0...10))
    }
}