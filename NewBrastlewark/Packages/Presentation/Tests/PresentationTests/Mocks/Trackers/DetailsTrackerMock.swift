import Foundation
@testable import Presentation

final class DetailsTrackerMock: DetailsTrackerProtocol {
    private let storage = Storage()

    func track(event: DetailsTrackingEvent) {
        Task {
            await storage.addEvent(event)
        }
    }

    func didTrackEvent(_ event: DetailsTrackingEvent) async -> Bool {
        return await storage.contains(event)
    }
}

private actor Storage {
    var events: [DetailsTrackingEvent] = []

    func addEvent(_ event: DetailsTrackingEvent) {
        events.append(event)
    }

    func contains(_ event: DetailsTrackingEvent) -> Bool {
        return events.contains {
            switch ($0, event) {
            case (.homeTapped, .homeTapped):
                return true
            case (.screenViewed(let id1), .screenViewed(let id2)):
                return id1 == id2
            case (.friendSelected(let id1), .friendSelected(let id2)):
                return id1 == id2
            case (.errorScreenViewed, .errorScreenViewed):
                return true
            default:
                return false
            }
        }
    }
}
