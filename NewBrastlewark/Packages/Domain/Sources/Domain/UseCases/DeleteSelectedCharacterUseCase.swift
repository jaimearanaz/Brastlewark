public protocol DeleteSelectedCharacterUseCaseProtocol {
    func execute() async -> Result<Void, CharactersRepositoryError>
}

final class DeleteSelectedCharacterUseCase: DeleteSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<Void, CharactersRepositoryError> {
        do {
            try await repository.deleteSelectedCharacter()
            return .success(())
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToDeleteSelectedCharacter)
        }
    }
}
