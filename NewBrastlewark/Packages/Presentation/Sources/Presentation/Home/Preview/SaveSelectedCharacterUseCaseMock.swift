import Foundation
import Domain

public final class SaveSelectedCharacterUseCaseMock: SaveSelectedCharacterUseCaseProtocol {
    public init() {}
    
    public func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, CharactersRepositoryError> {
        .success(())
    }
}