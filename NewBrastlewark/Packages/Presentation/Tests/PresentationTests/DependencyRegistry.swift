import Foundation
import Swinject

@testable import Domain

@MainActor
enum DependencyRegistry {
    static func createFreshContainer() -> Container {
        let container = Container()
        PresentationTestsModule.registerDependencies(inContainer: container)
        return container
    }
}
