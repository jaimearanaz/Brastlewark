public struct GetAllCharactersUseCaseParams {
    public let forceUpdate: Bool

    public init(forceUpdate: Bool) {
        self.forceUpdate = forceUpdate
    }
}

public protocol GetAllCharactersUseCaseProtocol {
    func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError>
}

final class GetAllCharactersUseCase: GetAllCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: params.forceUpdate)
            return .success(characters)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToFetchCharacters)
        }
    }
}
