import Foundation

public enum AppLog {
    public static let configuration = LogConfiguration.shared

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
