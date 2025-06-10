//import Swinject

public struct DomainModule {
//    public static func registerDependencies(inContainer container: Container) {
//        registerCharacterUseCases(in: container)
//        registerFilterUseCases(in: container)
//    }
//
//    private static func registerCharacterUseCases(in container: Container) {
//        container.register(GetAllCharactersUseCaseProtocol.self) { r in
//            GetAllCharactersUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//        container.register(GetFilteredCharactersUseCaseProtocol.self) { r in
//            GetFilteredCharactersUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//        container.register(SaveSelectedCharacterUseCaseProtocol.self) { r in
//            SaveSelectedCharacterUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//        container.register(GetSelectedCharacterUseCaseProtocol.self) { r in
//            GetSelectedCharacterUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//        container.register(DeleteSelectedCharacterUseCaseProtocol.self) { r in
//            DeleteSelectedCharacterUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//        container.register(GetSearchedCharacterUseCaseProtocol.self) { r in
//            GetSearchedCharacterUseCase(repository: resolveOrFail(r, CharactersRepositoryProtocol.self))
//        }
//    }
//
//    private static func registerFilterUseCases(in container: Container) {
//        container.register(GetAvailableFilterUseCaseProtocol.self) { r in
//            GetAvailableFilterUseCase(
//                charactersRepository: resolveOrFail(r, CharactersRepositoryProtocol.self),
//                filterRepository: resolveOrFail(r, FilterRepositoryProtocol.self)
//            )
//        }
//        container.register(SaveActiveFilterUseCaseProtocol.self) { r in
//            SaveActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
//        }
//        container.register(GetActiveFilterUseCaseProtocol.self) { r in
//            GetActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
//        }
//        container.register(DeleteActiveFilterUseCaseProtocol.self) { r in
//            DeleteActiveFilterUseCase(repository: resolveOrFail(r, FilterRepositoryProtocol.self))
//        }
//    }
//
//    private static func resolveOrFail<Service>(
//        _ resolver: Resolver,
//        _ serviceType: Service.Type) -> Service {
//        guard let service = resolver.resolve(serviceType) else {
//            fatalError("Dependency \(serviceType) not resolved")
//        }
//        return service
//    }
}
