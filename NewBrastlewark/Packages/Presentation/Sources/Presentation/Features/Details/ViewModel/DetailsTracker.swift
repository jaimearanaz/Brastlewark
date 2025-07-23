public protocol DetailsTrackerProtocol: Sendable {
    func track(event: DetailsTrackingEvent)
}

public enum DetailsTrackingEvent: Sendable {
    case screenViewed(characterId: Int)
    case homeTapped
    case friendSelected(characterId: Int)
    case errorScreenViewed
}

final class DetailsTracker: DetailsTrackerProtocol {
    private let analytics: AnalyticsProtocol

    init(analytics: AnalyticsProtocol) {
        self.analytics = analytics
    }

    // swiftlint:disable todo
    func track(event: DetailsTrackingEvent) {
        // TODO: implement with analytics service
    }
    // swiftlint:enable todo
}
