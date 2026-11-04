import Foundation
import Swinject

@testable import Domain

enum DependencyRegistry {
    static func createFreshContainer() -> Container {
        let container = Container()
        DataTestsModule.registerDependencies(inContainer: container)
        return container
    }
}
