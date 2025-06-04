public protocol GetActiveFilterUseCaseProtocol {
    func execute() async -> Result<Filter?, Error>
}

final class GetActiveFilterUseCase: GetActiveFilterUseCaseProtocol {
    private let repository: FilterRepositoryProtocol

    init(repository: FilterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Filter?, Error> {
        do {
            let filter = try await repository.getActiveFilter()
            return .success(filter)
        } catch {
            return .failure(error)
        }
    }
}
