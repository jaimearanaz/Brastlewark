public struct SaveSelectedCharacterUseCaseParams {
    public let id: Int
    public init(id: Int) {
        self.id = id
    }
}

public protocol SaveSelectedCharacterUseCaseProtocol {
    func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, CharactersRepositoryError>
}

final class SaveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, CharactersRepositoryError> {
        do {
            try await repository.saveSelectedCharacter(id: params.id)
            return .success(())
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToSaveSelectedCharacter)
        }
    }
}
