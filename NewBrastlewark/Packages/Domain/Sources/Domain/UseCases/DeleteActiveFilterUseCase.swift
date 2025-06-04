public protocol DeleteActiveFilterUseCaseProtocol {
    func execute() async -> Result<Void, Error>
}

final class DeleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol {
    private let repository: FilterRepositoryProtocol

    init(repository: FilterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<Void, Error> {
        do {
            try await repository.deleteActiveFilter()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
