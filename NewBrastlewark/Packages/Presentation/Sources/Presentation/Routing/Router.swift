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
        switch route {
        case .filter:
            log("navigating to filter, previous depth: \(path.count)", .navigation, .debug)
        case .details(let characterId, let showHome):
            log(
                "navigating to details, character id: \(characterId), show home: \(showHome), previous depth: \(path.count)",
                .navigation,
                .debug
            )
        }
        path.append(route)
    }

    public func navigateBack() {
        log("navigating back, previous depth: \(path.count)", .navigation, .debug)
        path.removeLast()
    }

    public func navigateToRoot() {
        log("navigating to root, previous depth: \(path.count)", .navigation, .debug)
        path.removeLast(path.count)
    }

    public func popToView(count: Int) {
        log("popping views, count: \(count), previous depth: \(path.count)", .navigation, .debug)
        path.removeLast(count)
    }

    public func canNavigateBack() -> Bool {
        return !path.isEmpty
    }
}

extension Router: PresentationLoggable {
    static let logSource = "Router"
}
