import Utils

enum PresentationLogCategory {
    case interaction
    case viewModel
    case navigation

    var logger: AppLogger {
        switch self {
        case .interaction:
            PresentationLog.interaction
        case .viewModel:
            PresentationLog.viewModel
        case .navigation:
            PresentationLog.navigation
        }
    }
}

protocol PresentationLoggable {
    static var logSource: String { get }
}

extension PresentationLoggable {
    func log(
        _ message: @autoclosure () -> String,
        _ category: PresentationLogCategory,
        _ level: AppLogLevel
    ) {
        category.logger.log(
            message(),
            source: Self.logSource,
            prefix: "🎨",
            level: level
        )
    }
}
