import OSLog

public enum AppLogLevel: Sendable {
    case debug
    case info
    case notice
    case warning
    case error
    case fault
}

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

    public func log(
        _ message: @autoclosure () -> String,
        source: String,
        prefix: String,
        level: AppLogLevel
    ) {
        guard isEnabled else { return }

        let formattedMessage = "\(prefix) \(source): \(message())"
        switch level {
        case .debug:
            logger.debug("\(formattedMessage, privacy: .public)")
        case .info:
            logger.info("\(formattedMessage, privacy: .public)")
        case .notice:
            logger.notice("\(formattedMessage, privacy: .public)")
        case .warning:
            logger.warning("\(formattedMessage, privacy: .public)")
        case .error:
            logger.error("\(formattedMessage, privacy: .public)")
        case .fault:
            logger.fault("\(formattedMessage, privacy: .public)")
        }
    }

    public func write(_ operation: (Logger) -> Void) {
        guard isEnabled else { return }
        operation(logger)
    }
}
