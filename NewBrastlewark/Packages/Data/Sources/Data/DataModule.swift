import Domain
import Swinject

public struct DataModule {
    public static func registerDependencies(inContainer container: Container) {
        registerRepositories(in: container)
        registerOthers(in: container)
    }

    private static func registerRepositories(in container: Container) {
        container.register(CharactersRepositoryProtocol.self) { r in
            CharactersRepository(
                networkService: resolveOrFail(r, NetworkServiceProtocol.self),
                cache: resolveOrFail(r, CharactersCacheProtocol.self))
        }
        .inObjectScope(.container)
        container.register(FilterRepositoryProtocol.self) { _ in
            FilterRepository()
        }
        .inObjectScope(.container)
    }

    private static func registerOthers(in container: Container) {
        container.register(NetworkStatusProtocol.self) { _ in NetworkStatus() }
        container.register(NetworkServiceProtocol.self) { r in
            NetworkService(
                baseUrl: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json",
                networkStatus: resolveOrFail(r, NetworkStatusProtocol.self))
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
