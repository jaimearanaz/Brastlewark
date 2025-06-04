public protocol GetSelectedCharacterUseCaseProtocol {
    func execute() async -> Result<Character?, Error>
}

final class GetSelectedCharacterUseCase: GetSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Character?, Error> {
        do {
            let character = try await repository.getSelectedCharacter()
            return .success(character)
        } catch {
            return .failure(error)
        }
    }
}
