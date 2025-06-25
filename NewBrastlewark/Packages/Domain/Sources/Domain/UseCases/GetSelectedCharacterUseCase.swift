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
            let id = try await repository.getSelectedCharacter()
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            return .success(characters.filter { $0.id == id }.first)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToGetSelectedCharacter)
        }
    }
}
