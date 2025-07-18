import Swinject

@testable import Domain

public struct DomainTestsModule {
    public static func registerDependencies(inContainer container: Container) {
        registerMockRepositories(in: container)
        registerCharacterUseCases(in: container)
        registerFilterUseCases(in: container)
    }

    private static func registerMockRepositories(in container: Container) {
        container.register(CharactersRepositoryProtocol.self) { _ in
            CharactersRepositoryMock()
        }.inObjectScope(.container)

        container.register(FilterRepositoryProtocol.self) { _ in
            FilterRepositoryMock()
        }.inObjectScope(.container)
    }

    private static func registerCharacterUseCases(in container: Container) {
        container.register(GetAllCharactersUseCaseProtocol.self) { r in
            GetAllCharactersUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
        }
        container.register(GetFilteredCharactersUseCaseProtocol.self) { r in
            GetFilteredCharactersUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
        }
        container.register(GetSearchedCharacterUseCaseProtocol.self) { r in
            GetSearchedCharacterUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
        }
        container.register(GetCharacterByIdUseCaseProtocol.self) { r in
            GetCharacterByIdUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
        }
    }

    private static func registerFilterUseCases(in container: Container) {
        container.register(GetAvailableFilterUseCaseProtocol.self) { r in
            GetAvailableFilterUseCase(
                charactersRepository: resolveOrFail(r, CharactersRepositoryProtocol.self),
                filterRepository: resolveOrFail(r, FilterRepositoryProtocol.self)
            )
        }
        container.register(SaveActiveFilterUseCaseProtocol.self) { r in
            SaveActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
        }
        container.register(GetActiveFilterUseCaseProtocol.self) { r in
            GetActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
        }
        container.register(DeleteActiveFilterUseCaseProtocol.self) { r in
            DeleteActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
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
