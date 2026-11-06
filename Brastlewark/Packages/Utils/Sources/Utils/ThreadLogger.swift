import Foundation
import OSLog

public struct ThreadLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.brastlewark.app"
    private static let logger = Logger(subsystem: subsystem, category: "ThreadMonitor")

    public static func log(file: String = #file, function: String = #function, message: String = "") {
        let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent

        var methodName = function
        if let parenthesisIndex = function.firstIndex(of: "(") {
            methodName = String(function[..<parenthesisIndex])
        }

        let threadInfo: String
        if Thread.isMainThread {
            threadInfo = "MAIN THREAD"
        } else {
            let currentThread = Thread.current
            threadInfo = "BACKGROUND THREAD: \(currentThread.description)"
        }

        logger.debug("🧵 [\(fileName)] [\(methodName)] - \(threadInfo) \(message.isEmpty ? "" : "- \(message)")")
    }
}
