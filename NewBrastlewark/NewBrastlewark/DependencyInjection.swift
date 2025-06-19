import Data
import Domain
import Presentation
import Swinject

@MainActor
public enum DIContainer {
    public static let shared: Container = {
        let container = Container()
        DataModule.registerDependencies(inContainer: container)
        DomainModule.registerDependencies(inContainer: container)
        PresentationModule.registerDependencies(inContainer: container)
        return container
    }()
}
