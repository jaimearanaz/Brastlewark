import Swinject

public struct DomainModule {
    public static func registerDependencies(inContainer container: Container) {
        registerCharacterUseCases(in: container)
        registerFilterUseCases(in: container)
    }

    private static func registerCharacterUseCases(in container: Container) {
        container.register(GetAllCharactersUseCaseProtocol.self) { resolver in
            GetAllCharactersUseCase(repository: resolveOrFail(resolver, CharactersRepositoryProtocol.self))
        }
        container.register(GetFilteredCharactersUseCaseProtocol.self) { resolver in
            GetFilteredCharactersUseCase(repository: resolveOrFail(resolver, CharactersRepositoryProtocol.self))
        }
        container.register(GetSearchedCharacterUseCaseProtocol.self) { resolver in
            GetSearchedCharacterUseCase(repository: resolveOrFail(resolver, CharactersRepositoryProtocol.self))
        }
        container.register(GetCharacterByIdUseCaseProtocol.self) { resolver in
            GetCharacterByIdUseCase(repository: resolveOrFail(resolver, CharactersRepositoryProtocol.self))
        }
    }

    private static func registerFilterUseCases(in container: Container) {
        container.register(GetAvailableFilterUseCaseProtocol.self) { resolver in
            GetAvailableFilterUseCase(
                charactersRepository: resolveOrFail(resolver, CharactersRepositoryProtocol.self),
                filterRepository: resolveOrFail(resolver, FilterRepositoryProtocol.self)
            )
        }
        container.register(SaveActiveFilterUseCaseProtocol.self) { resolver in
            SaveActiveFilterUseCase(repository: resolveOrFail(resolver, FilterRepositoryProtocol.self))
        }
        container.register(GetActiveFilterUseCaseProtocol.self) { resolver in
            GetActiveFilterUseCase(repository: resolveOrFail(resolver, FilterRepositoryProtocol.self))
        }
        container.register(DeleteActiveFilterUseCaseProtocol.self) { resolver in
            DeleteActiveFilterUseCase(repository: resolveOrFail(resolver, FilterRepositoryProtocol.self))
        }
    }

    private static func resolveOrFail<Service>(
        _ resolver: Resolver,
        _ serviceType: Service.Type) -> Service {
        guard let service = resolver.resolve(serviceType) else {
            fatalError("Dependency \(serviceType) not resolved")
        }
        return service
    }
}
