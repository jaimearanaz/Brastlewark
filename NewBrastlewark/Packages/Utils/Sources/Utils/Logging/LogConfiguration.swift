import Synchronization

public final class LogConfiguration: Sendable {
    private struct State: Sendable {
        var enabledCategories: Set<LogCategory>
    }

    public static let shared = LogConfiguration()

    private let state: Mutex<State>

    public init(enabledCategories: Set<LogCategory> = Set(LogCategory.allCases)) {
        state = Mutex(State(enabledCategories: enabledCategories))
    }

    public func isEnabled(_ category: LogCategory) -> Bool {
        state.withLock { state in
            state.enabledCategories.contains(category)
        }
    }

    public func enable(_ category: LogCategory) {
        _ = state.withLock { state in
            state.enabledCategories.insert(category)
        }
    }

    public func disable(_ category: LogCategory) {
        _ = state.withLock { state in
            state.enabledCategories.remove(category)
        }
    }

    public func enableAll() {
        state.withLock { state in
            state.enabledCategories = Set(LogCategory.allCases)
        }
    }

    public func disableAll() {
        state.withLock { state in
            state.enabledCategories.removeAll()
        }
    }
}
