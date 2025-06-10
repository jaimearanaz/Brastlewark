public struct GetSearchedCharacterUseCaseParams {
    let searchText: String

    public init(searchText: String) {
        self.searchText = searchText
    }
}

public protocol GetSearchedCharacterUseCaseProtocol {
    func execute(params: GetSearchedCharacterUseCaseParams) async -> Result<[Character], CharactersRepositoryError>
}

final class GetSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetSearchedCharacterUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            let searchedCharacters = searchCharacters(characters, withSearchText: params.searchText)
            return .success(searchedCharacters)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToFetchCharacters)
        }
    }
}

private extension GetSearchedCharacterUseCase {
    private func searchCharacters(_ characters: [Character], withSearchText searchText: String) -> [Character] {
        guard !searchText.isEmpty else { return characters }

        let lowercasedSearchText = searchText.lowercased()
        return characters.filter { character in
            character.name.lowercased().contains(lowercasedSearchText) ||
            character.professions.contains(where: { $0.lowercased().contains(lowercasedSearchText) })
        }
    }
}
