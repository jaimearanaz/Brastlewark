import Swinject

public struct DomainModule {
    public static func registerDependencies(inContainer container: Container) {
        container.register(GetAllCharactersUseCaseProtocol.self) { r in
            guard let repository = r.resolve(CharactersRepositoryProtocol.self) else {
                fatalError("Dependency CharactersRepositoryProtocol not resolved")
            }
            return GetAllCharactersUseCase(repository: repository)
        }
        container.register(GetAvailableFilterUseCaseProtocol.self) { r in
            guard let charactersRepository = r.resolve(CharactersRepositoryProtocol.self) else {
                fatalError("Dependency CharactersRepositoryProtocol not resolved")
            }
            guard let filterRepository = r.resolve(FilterRepositoryProtocol.self) else {
                fatalError("Dependency FilterRepositoryProtocol not resolved")
            }
            return GetAvailableFilterUseCase(
                charactersRepository: charactersRepository,
                filterRepository: filterRepository)
        }
        container.register(GetFilteredCharactersUseCaseProtocol.self) { r in
            guard let repository = r.resolve(CharactersRepositoryProtocol.self) else {
                fatalError("Dependency CharactersRepositoryProtocol not resolved")
            }
            return GetFilteredCharactersUseCase(repository: repository)
        }
    }
}

