public struct SaveActiveFilterUseCaseParams {
    public let filter: Filter

    public init(filter: Filter) {
        self.filter = filter
    }
}

public protocol SaveActiveFilterUseCaseProtocol {
    func execute(params: SaveActiveFilterUseCaseParams) async -> Result<Void, Error>
}

final class SaveActiveFilterUseCase: SaveActiveFilterUseCaseProtocol {
    private let repository: FilterRepositoryProtocol

    init(repository: FilterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(params: SaveActiveFilterUseCaseParams) async -> Result<Void, Error> {
        do {
            try await repository.saveActiveFilter(params.filter)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
