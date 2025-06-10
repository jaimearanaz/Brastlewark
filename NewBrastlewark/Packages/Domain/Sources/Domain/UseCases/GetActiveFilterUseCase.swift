public protocol GetActiveFilterUseCaseProtocol {
    func execute() async -> Result<Filter?, FilterRepositoryError>
}

final class GetActiveFilterUseCase: GetActiveFilterUseCaseProtocol {
    private let repository: FilterRepositoryProtocol

    init(repository: FilterRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<Filter?, FilterRepositoryError> {
        do {
            let filter = try await repository.getActiveFilter()
            return .success(filter)
        } catch let error as FilterRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToFetchFilter)
        }
    }
}
