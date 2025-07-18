import Swinject
import Foundation

@testable import Domain

enum DependencyRegistry {
    static func createFreshContainer() -> Container {
        let container = Container()
        DomainTestsModule.registerDependencies(inContainer: container)
        return container
    }
}
