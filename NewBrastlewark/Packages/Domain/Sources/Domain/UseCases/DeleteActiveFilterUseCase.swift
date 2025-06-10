public protocol DeleteActiveFilterUseCaseProtocol {
    func execute() async -> Result<Void, FilterRepositoryError>
}

final class DeleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol {
    private let repository: FilterRepositoryProtocol

    init(repository: FilterRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Result<Void, FilterRepositoryError> {
        do {
            try await repository.deleteActiveFilter()
            return .success(())
        } catch let error as FilterRepositoryError {
            return .failure(error)
        } catch {
            return .failure(.unableToDeleteFilter)
        }
    }
}
