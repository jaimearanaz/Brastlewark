import Foundation
@testable import Presentation

final class HomeTrackerMock: HomeTrackerProtocol {
    private let storage = Storage()

    func track(event: HomeTrackingEvent) {
        Task {
            await storage.addEvent(event)
        }
    }

    func didTrackEvent(_ event: HomeTrackingEvent) async -> Bool {
        return await storage.contains(event)
    }
}

private actor Storage {
    var events: [HomeTrackingEvent] = []

    func addEvent(_ event: HomeTrackingEvent) {
        events.append(event)
    }

    func contains(_ event: HomeTrackingEvent) -> Bool {
        return events.contains {
            switch ($0, event) {
            case (.screenViewed, .screenViewed),
                 (.resetTapped, .resetTapped),
                 (.filterTapped, .filterTapped),
                 (.refreshed, .refreshed),
                 (.emptyScreenViewed, .emptyScreenViewed),
                 (.errorScreenViewed, .errorScreenViewed):
                return true
            case (.searchChanged(let text1), .searchChanged(let text2)):
                return text1 == text2
            case (.characterSelected(let id1), .characterSelected(let id2)):
                return id1 == id2
            default:
                return false
            }
        }
    }
}
