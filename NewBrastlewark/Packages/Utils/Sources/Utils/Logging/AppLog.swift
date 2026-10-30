import Foundation

public enum AppLog {
    public static let configuration = LogConfiguration.shared

    public static let network = makeLogger(for: .network)
    public static let decoding = makeLogger(for: .decoding)
    public static let persistence = makeLogger(for: .persistence)
    public static let repository = makeLogger(for: .repository)
    public static let domain = makeLogger(for: .domain)
    public static let viewModel = makeLogger(for: .viewModel)
    public static let interaction = makeLogger(for: .interaction)
    public static let navigation = makeLogger(for: .navigation)
    public static let lifecycle = makeLogger(for: .lifecycle)
    public static let performance = makeLogger(for: .performance)
    public static let diagnostics = makeLogger(for: .diagnostics)

    public static func makeLogger(for category: LogCategory) -> AppLogger {
        AppLogger(
            subsystem: subsystem,
            category: category,
            configuration: configuration
        )
    }

    private static let subsystem =
        Bundle.main.bundleIdentifier ?? "com.brastlewark.app"
}
