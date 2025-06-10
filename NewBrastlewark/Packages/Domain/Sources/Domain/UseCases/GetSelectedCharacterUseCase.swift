public protocol GetSelectedCharacterUseCaseProtocol {
    func execute() async -> Result<Character?, CharactersRepositoryError>
}

final class GetSelectedCharacterUseCase: GetSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<Character?, CharactersRepositoryError> {
        do {
            let character = try await repository.getSelectedCharacter()
            return .success(character)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToGetSelectedCharacter)
        }
    }
}
