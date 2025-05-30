import Foundation

protocol GetAllCharactersUseCase {
    func execute() async -> Result<[Character], Error>
}

final class GetAllCharactersUseCaseImpl: GetAllCharactersUseCase {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<[Character], Error> {
        do {
            let characters = try await repository.getCharacters()
            return .success(characters)
        } catch {
            return .failure(error)
        }
    }
}
