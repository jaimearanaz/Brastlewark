import Synchronization

public final class LogConfiguration: Sendable {
    private struct State: Sendable {
        var defaultEnabled = true
        var categoryOverrides: [LogCategory: Bool] = [:]
    }

    public static let shared = LogConfiguration()

    private let state = Mutex(State())

    public init() {}

    public func isEnabled(_ category: LogCategory) -> Bool {
        state.withLock { state in
            state.categoryOverrides[category] ?? state.defaultEnabled
        }
    }

    public func enable(_ category: LogCategory) {
        state.withLock { state in
            state.categoryOverrides[category] = true
        }
    }

    public func disable(_ category: LogCategory) {
        state.withLock { state in
            state.categoryOverrides[category] = false
        }
    }

    public func enableAll() {
        state.withLock { state in
            state.defaultEnabled = true
            state.categoryOverrides.removeAll()
        }
    }

    public func disableAll() {
        state.withLock { state in
            state.defaultEnabled = false
            state.categoryOverrides.removeAll()
        }
    }
}
