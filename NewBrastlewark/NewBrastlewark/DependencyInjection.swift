import Data
import Domain
import Swinject

// TODO: this shouldn't be a main actor
@MainActor
public enum DIContainer {
    public static let shared: Container = {
        let container = Container()
        // DataModule.registerDependencies(inContainer: container)
        // DomainModule.registerDependencies(inContainer: container)
        return container
    }()
}
