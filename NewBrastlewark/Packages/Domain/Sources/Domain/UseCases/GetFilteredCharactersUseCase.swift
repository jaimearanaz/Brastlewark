public struct GetFilteredCharactersUseCaseParams {
    let filter: Filter

    public init(filter: Filter) {
        self.filter = filter
    }
}

public protocol GetFilteredCharactersUseCaseProtocol {
    func execute(params: GetFilteredCharactersUseCaseParams) async -> Result<[Character], Error>
}

final class GetFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(params: GetFilteredCharactersUseCaseParams) async -> Result<[Character], Error> {
        do {
            let characters = try await repository.getAllCharacters(forceUpdate: false)
            let filtered = filterCharacters(characters, withFilter: params.filter)
            return .success(filtered)
        } catch {
            return .failure(error)
        }
    }
}

private extension GetFilteredCharactersUseCase {
    private func filterCharacters(_ characters: [Character], withFilter filter: Filter) -> [Character] {
        return characters
            .filter { filter.age.contains($0.age) }
            .filter { filter.weight.contains(Int($0.weight)) }
            .filter { filter.height.contains(Int($0.height)) }
            .filter { filter.hairColor.contains($0.hairColor) }
            .filter { filter.profession.map{ $0.uppercased() }
                .containsOneOrMoreOfElements(in: $0.professions.map{ $0.uppercased() }) }
            .filter { filter.friends.contains($0.friends.count) }
    }
}
