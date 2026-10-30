import OSLog

public struct AppLogger: Sendable {
    public let category: LogCategory

    private let logger: Logger
    private let configuration: LogConfiguration

    public init(
        subsystem: String,
        category: LogCategory,
        configuration: LogConfiguration = .shared
    ) {
        self.category = category
        self.logger = Logger(subsystem: subsystem, category: category.rawValue)
        self.configuration = configuration
    }

    public var isEnabled: Bool {
        configuration.isEnabled(category)
    }

    public func write(_ operation: (Logger) -> Void) {
        guard isEnabled else { return }
        operation(logger)
    }
}
