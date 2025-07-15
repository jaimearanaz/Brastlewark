public protocol FilterTrackerProtocol: Sendable {
    func track(event: FilterTrackingEvent)
}

public enum FilterTrackingEvent: Sendable {
    case screenViewed
    case resetTapped
    case applyTapped
    case ageChanged(age: ClosedRange<Int>)
    case weightChanged(weight: ClosedRange<Int>)
    case heightChanged(height: ClosedRange<Int>)
    case hairColorChanged(title: String, checked: Bool)
    case hairColorReset
    case professionChanged(title: String, checked: Bool)
    case professionReset
    case friendsChanged(friends: ClosedRange<Int>)
}

final class FilterTracker: FilterTrackerProtocol {
    private let analytics: AnalyticsProtocol

    init(analytics: AnalyticsProtocol) {
        self.analytics = analytics
    }

    func track(event: FilterTrackingEvent) {
        // TODO: implement with analytics service
    }
}
