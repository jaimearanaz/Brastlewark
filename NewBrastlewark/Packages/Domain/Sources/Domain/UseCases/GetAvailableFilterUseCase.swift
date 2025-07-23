public enum GetAvailableFilterUseCaseError: Error {
    case noInternetConnection
    case unableToFetchCharacters
    case unableToGetAvailableFilter
}

public protocol GetAvailableFilterUseCaseProtocol {
    func execute() async -> Result<Filter, GetAvailableFilterUseCaseError>
}

final class GetAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol {
    private let charactersRepository: CharactersRepositoryProtocol
    private let filterRepository: FilterRepositoryProtocol

    init(charactersRepository: CharactersRepositoryProtocol,
         filterRepository: FilterRepositoryProtocol) {
        self.charactersRepository = charactersRepository
        self.filterRepository = filterRepository
    }

    func execute() async -> Result<Filter, GetAvailableFilterUseCaseError> {
        do {
            let characters = try await charactersRepository.getAllCharacters(forceUpdate: false)
            let filter = try await filterRepository.getAvailableFilter(fromCharacters: characters)
            return .success(filter)
        } catch let error as CharactersRepositoryError {
            switch error {
            case .noInternetConnection:
                return .failure(.noInternetConnection)
            default:
                return .failure(.unableToFetchCharacters)
            }
        } catch let error as FilterRepositoryError {
            switch error {
            case .noInternetConnection:
                return .failure(.noInternetConnection)
            default:
                return .failure(.unableToGetAvailableFilter)
            }
        } catch {
            return .failure(.unableToGetAvailableFilter)
        }
    }
}
