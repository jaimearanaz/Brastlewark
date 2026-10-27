public protocol DeleteActiveFilterUseCaseProtocol: Sendable {
    func execute() async -> Result<Void, FilterRepositoryError>
}

final class DeleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol, @unchecked Sendable {
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
