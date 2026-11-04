@testable import Data
import Domain
import Swinject

public struct DataTestsModule {
    public static func registerDependencies(inContainer container: Container) {
        registerRepositories(in: container)
        registerOthers(in: container)
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

    private static func registerOthers(in container: Container) {
        container.register(NetworkStatusProtocol.self) { _ in NetworkStatusMock() }
            .inObjectScope(.container)
        container.register(NetworkServiceProtocol.self) { _ in NetworkServiceMock() }
            .inObjectScope(.container)
        container.register(CharactersCacheProtocol.self) { _ in CacheMock() }
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
