import Swinject
import Foundation

@testable import Domain

enum DependencyRegistry {
    static func createFreshContainer() -> Container {
        let container = Container()
        DataTestsModule.registerDependencies(inContainer: container)
        return container
    }
}
