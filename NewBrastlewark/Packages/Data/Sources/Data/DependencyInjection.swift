import Swinject
import Domain

@MainActor
public enum DIContainer {
    public static let shared: Container = {
        let container = Container()
        container.register(NetworkStatusProtocol.self) { _ in NetworkStatus() }
        container.register(NetworkServiceProtocol.self) { r in
            guard let networkStatus = r.resolve(NetworkStatusProtocol.self) else {
                fatalError("Dependency NetworkStatusProtocol not resolved")
            }
            return NetworkService(
                baseUrl: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json",
                networkStatus: networkStatus)
        }
        container.register(CharactersRepositoryProtocol.self) { r in
            guard let networkService = r.resolve(NetworkServiceProtocol.self) else {
                fatalError("Dependency NetworkStatusProtocol not resolved")
            }
            return CharactersRepository(networkService: networkService)
        }
        return container
    }()
}
