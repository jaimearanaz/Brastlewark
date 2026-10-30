import SwiftUI

public protocol RouterProtocol: ObservableObject {
    var path: NavigationPath { get set }

    func navigate(to route: Route)
    func navigateBack()
    func navigateToRoot()
    func popToView(count: Int)
    func canNavigateBack() -> Bool
}

public class Router: RouterProtocol {
    @Published public var path = NavigationPath()

    public init() {}

    public func navigate(to route: Route) {
        path.append(route)
    }

    public func navigateBack() {
        path.removeLast()
    }

    public func navigateToRoot() {
        path.removeLast(path.count)
    }

    public func popToView(count: Int) {
        path.removeLast(count)
    }

    public func canNavigateBack() -> Bool {
        return !path.isEmpty
    }
}
