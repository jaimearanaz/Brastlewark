import Foundation

public struct GetAllCharactersUseCaseParams {
    let forceUpdate: Bool

    public init(forceUpdate: Bool) {
        self.forceUpdate = forceUpdate
    }
}

public protocol GetAllCharactersUseCaseProtocol {
    func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], Error>
}

final class GetAllCharactersUseCase: GetAllCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], Error> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: params.forceUpdate)
            return .success(characters)
        } catch {
            return .failure(error)
        }
    }
}
