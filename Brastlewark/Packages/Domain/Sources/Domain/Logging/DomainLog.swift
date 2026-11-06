import Utils

public enum DomainLog {
    public static let useCase = AppLog.makeLogger(
        for: LogCategory(rawValue: "domain.usecase")
    )
    public static let validation = AppLog.makeLogger(
        for: LogCategory(rawValue: "domain.validation")
    )
    public static let businessRule = AppLog.makeLogger(
        for: LogCategory(rawValue: "domain.business-rule")
    )
}

enum DomainLogCategory {
    case useCase
    case validation
    case businessRule

    var logger: AppLogger {
        switch self {
        case .useCase:
            DomainLog.useCase
        case .validation:
            DomainLog.validation
        case .businessRule:
            DomainLog.businessRule
        }
    }
}

protocol DomainLoggable {
    static var logSource: String { get }
}

extension DomainLoggable {
    func log(
        _ message: @autoclosure () -> String,
        _ category: DomainLogCategory,
        _ level: AppLogLevel
    ) {
        category.logger.log(
            message(),
            source: Self.logSource,
            prefix: "🧠",
            level: level
        )
    }
}
