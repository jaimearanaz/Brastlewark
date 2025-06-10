public struct GetFilteredCharactersUseCaseParams {
    let filter: Filter

    public init(filter: Filter) {
        self.filter = filter
    }
}

public protocol GetFilteredCharactersUseCaseProtocol {
    func execute(params: GetFilteredCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError>
}

final class GetFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetFilteredCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            let filtered = filterCharacters(characters, withFilter: params.filter)
            return .success(filtered)
        } catch let error as CharactersRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToFetchCharacters)
        }
    }
}

private extension GetFilteredCharactersUseCase {
    private func filterCharacters(_ characters: [Character], withFilter filter: Filter) -> [Character] {
        var filtered = characters
        if filter.age != 0...0 {
            filtered = filtered.filter { filter.age.contains($0.age) }
        }
        if filter.weight != 0...0 {
            filtered = filtered.filter { filter.weight.contains(Int($0.weight)) }
        }
        if filter.height != 0...0 {
            filtered = filtered.filter { filter.height.contains(Int($0.height)) }
        }
        if !filter.hairColor.isEmpty {
            filtered = filtered.filter { filter.hairColor.contains($0.hairColor) }
        }
        if !filter.profession.isEmpty {
            filtered = filtered.filter { filter.profession.map{ $0.uppercased() }
                .containsOneOrMoreOfElements(in: $0.professions.map{ $0.uppercased() }) }
        }
        if filter.friends != 0...0 {
            filtered = filtered.filter { filter.friends.contains($0.friends.count) }
        }
        return filtered
    }
}
