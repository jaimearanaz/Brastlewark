public struct GetCharacterByIdUseCaseParams {
    public let id: Int

    public init(id: Int) {
        self.id = id
    }
}

public protocol GetCharacterByIdUseCaseProtocol {
    func execute(params: GetCharacterByIdUseCaseParams) async -> Result<Character?, CharactersRepositoryError>
}

final class GetCharacterByIdUseCase: GetCharacterByIdUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetCharacterByIdUseCaseParams) async -> Result<Character?, CharactersRepositoryError> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            return .success(characters.filter { $0.id == params.id }.first)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToFetchCharacters)
        }
    }
}
