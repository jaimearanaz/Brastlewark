import Domain
import Swinject

public struct DataModule {
    public enum Source {
        case remote
        case local
    }

    public static func registerDependencies(
        inContainer container: Container,
        source: Source = .remote
    ) {
        registerRepositories(in: container)
        registerOthers(in: container, source: source)
    }

    private static func registerRepositories(in container: Container) {
        container.register(CharactersRepositoryProtocol.self) { resolver in
            CharactersRepository(
                networkService: resolveOrFail(resolver, NetworkServiceProtocol.self),
                cache: resolveOrFail(resolver, CharactersCacheProtocol.self))
        }
        .inObjectScope(.container)
        container.register(FilterRepositoryProtocol.self) { _ in
            FilterRepository()
        }
        .inObjectScope(.container)
    }

    private static func registerOthers(in container: Container, source: Source) {
        container.register(NetworkStatusProtocol.self) { _ in NetworkStatus() }
        container.register(NetworkServiceProtocol.self) { resolver in
            switch source {
            case .remote:
                NetworkService(
                    baseUrl: "https://raw.githubusercontent.com/jaimearanaz/Brastlewark/refs/heads/main/data/brastlewark.json",
                    networkStatus: resolveOrFail(resolver, NetworkStatusProtocol.self))
            case .local:
                LocalService()
            }
        }
        container.register(CharactersCacheProtocol.self) { _ in
            guard let cache = PersistentCharactersCache() else {
                fatalError("Persistent cache is not initialized")
            }
            return cache
        }
        .inObjectScope(.container)
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
