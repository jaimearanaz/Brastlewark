import SwiftUI

@testable import Presentation

public final class RouterMock: RouterProtocol {
    @Published public var path = NavigationPath()

    public private(set) var didNavigateToRoute: (called: Bool, route: Route?) = (false, nil)
    public private(set) var didNavigateBack: Bool = false
    public private(set) var didNavigateToRoot: Bool = false
    public private(set) var didPopToView: (called: Bool, count: Int?) = (false, nil)
    public private(set) var didCheckCanNavigateBack: Bool = false
    public var canNavigateBackResult: Bool = false

    public init() {}

    public func navigate(to route: Route) {
        didNavigateToRoute = (true, route)
    }

    public func navigateBack() {
        didNavigateBack = true
    }

    public func navigateToRoot() {
        didNavigateToRoot = true
    }

    public func popToView(count: Int) {
        didPopToView = (true, count)
    }

    public func canNavigateBack() -> Bool {
        didCheckCanNavigateBack = true
        return canNavigateBackResult
    }
}
