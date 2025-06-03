import Foundation

protocol GetAllCharactersUseCaseProtocol {
    func execute() async -> Result<[Character], Error>
}

final class GetAllCharactersUseCase: GetAllCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<[Character], Error> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            return .success(characters)
        } catch {
            return .failure(error)
        }
    }
}
