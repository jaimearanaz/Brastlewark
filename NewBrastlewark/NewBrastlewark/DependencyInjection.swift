import Data
import Domain
import Presentation
import Swinject

@MainActor
public enum DIContainer {
    private static let dataSource: DataModule.Source = .local

    public static let shared: Container = {
        let container = Container()
        DataModule.registerDependencies(inContainer: container, source: dataSource)
        DomainModule.registerDependencies(inContainer: container)
        PresentationModule.registerDependencies(inContainer: container)
        return container
    }()
}
