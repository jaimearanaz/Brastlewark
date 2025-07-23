import SwiftUI

@testable import Presentation

public final class RouterMock: RouterProtocol, @unchecked Sendable {
    @Published public var path = NavigationPath()

    public private(set) var didNavigateToRoute: (called: Bool, route: Route?) = (false, nil)
    public private(set) var didNavigateBack = false
    public private(set) var didNavigateToRoot = false
    public private(set) var didPopToView: (called: Bool, count: Int?) = (false, nil)
    public private(set) var didCheckCanNavigateBack = false
    public var canNavigateBackResult = false

    private let lock = NSLock()

    public init() {}

    public func navigate(to route: Route) {
        lock.lock()
        defer { lock.unlock() }
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
