import SwiftUI

public class Router: ObservableObject {
    @Published public var path = NavigationPath()

    public init() {}

    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }

    func popToView(count: Int) {
        path.removeLast(count)
    }
}

extension Router {
    func canNavigateBack() -> Bool {
        return path.count > 0
    }
}
