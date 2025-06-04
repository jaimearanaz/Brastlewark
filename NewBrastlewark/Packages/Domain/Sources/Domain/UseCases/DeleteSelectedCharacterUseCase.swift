import Foundation

public protocol DeleteSelectedCharacterUseCaseProtocol {
    func execute() async -> Result<Void, Error>
}

final class DeleteSelectedCharacterUseCase: DeleteSelectedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Void, Error> {
        do {
            try await repository.deleteSelectedCharacter()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
