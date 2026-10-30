import Utils

public enum DataLog {
    public static let network = AppLog.makeLogger(
        for: LogCategory(rawValue: "data.network")
    )
    public static let decoding = AppLog.makeLogger(
        for: LogCategory(rawValue: "data.decoding")
    )
    public static let persistence = AppLog.makeLogger(
        for: LogCategory(rawValue: "data.persistence")
    )
    public static let repository = AppLog.makeLogger(
        for: LogCategory(rawValue: "data.repository")
    )
}

enum DataLogCategory {
    case network
    case decoding
    case persistence
    case repository

    var logger: AppLogger {
        switch self {
        case .network:
            DataLog.network
        case .decoding:
            DataLog.decoding
        case .persistence:
            DataLog.persistence
        case .repository:
            DataLog.repository
        }
    }
}

protocol DataLoggable {
    static var logSource: String { get }
}

extension DataLoggable {
    func log(
        _ message: @autoclosure () -> String,
        _ category: DataLogCategory,
        _ level: AppLogLevel
    ) {
        category.logger.log(
            message(),
            source: Self.logSource,
            prefix: "💾",
            level: level
        )
    }
}
