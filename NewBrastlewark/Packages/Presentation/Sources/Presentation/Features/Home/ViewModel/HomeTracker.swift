public protocol HomeTrackerProtocol: Sendable {
    func track(event: HomeTrackingEvent)
}

public enum HomeTrackingEvent: Sendable {
    case screenViewed
    case searchChanged(text: String)
    case filterTapped
    case resetTapped
    case refreshed
    case characterSelected(characterId: Int)
    case emptyScreenViewed
    case errorScreenViewed
}

final class HomeTracker: HomeTrackerProtocol {
    private let analytics: AnalyticsProtocol

    init(analytics: AnalyticsProtocol) {
        self.analytics = analytics
    }

    // swiftlint:disable todo
    func track(event: HomeTrackingEvent) {
        // TODO: implement with analytics service
    }
    // swiftlint:enable todo
}
