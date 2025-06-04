public struct SaveSelectedCharacterUseCaseParams {
    public let character: Character
    public init(character: Character) {
        self.character = character
    }
}

public protocol SaveSelectedCharacterUseCaseProtocol {
    func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, Error>
}

final class SaveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, Error> {
        do {
            try await repository.saveSelectedCharacter(params.character)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
