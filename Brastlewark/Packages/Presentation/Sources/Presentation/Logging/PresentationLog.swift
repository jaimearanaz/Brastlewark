import Utils

public enum PresentationLog {
    public static let viewModel = AppLog.makeLogger(
        for: LogCategory(rawValue: "presentation.viewmodel")
    )
    public static let interaction = AppLog.makeLogger(
        for: LogCategory(rawValue: "presentation.interaction")
    )
    public static let navigation = AppLog.makeLogger(
        for: LogCategory(rawValue: "presentation.navigation")
    )
}
