public protocol GetAvailableFilterUseCaseProtocol {
    func execute() async -> Result<Filter, Error>
}

final class GetAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol {
    private let charactersRepository: CharactersRepositoryProtocol
    private let filterRepository: FilterRepositoryProtocol

    init(charactersRepository: CharactersRepositoryProtocol,
        filterRepository: FilterRepositoryProtocol) {
        self.charactersRepository = charactersRepository
        self.filterRepository = filterRepository
    }

    func execute() async -> Result<Filter, Error> {
        do {
            let characters = try await charactersRepository.getAllCharacters(forceUpdate: false)
            let filter = try await filterRepository.getAvailableFilter(fromCharacters: characters)
            return .success(filter)
        } catch {
            return .failure(error)
        }
    }
}
