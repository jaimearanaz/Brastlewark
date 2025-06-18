import Foundation
import Domain

public final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol {
    public init() {}
    
    public func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        do {
            let characters = try loadCharactersFromJSON()
            return .success(characters)
        } catch {
            return .failure(.unableToFetchCharacters)
        }
    }
}
