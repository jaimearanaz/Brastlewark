import Foundation
@testable import Presentation

final class FilterTrackerMock: FilterTrackerProtocol {
    private let storage = Storage()

    func track(event: FilterTrackingEvent) {
        Task {
            await storage.addEvent(event)
        }
    }

    func didTrackEvent(_ event: FilterTrackingEvent) async -> Bool {
        return await storage.contains(event)
    }
}

private actor Storage {
    var events: [FilterTrackingEvent] = []

    func addEvent(_ event: FilterTrackingEvent) {
        events.append(event)
    }

    func contains(_ event: FilterTrackingEvent) -> Bool {
        return events.contains {
            switch ($0, event) {
            case (.screenViewed, .screenViewed),
                 (.resetTapped, .resetTapped),
                 (.applyTapped, .applyTapped),
                 (.hairColorReset, .hairColorReset),
                 (.professionReset, .professionReset):
                return true
            case (.ageChanged(let age1), .ageChanged(let age2)):
                return age1 == age2
            case (.weightChanged(let weight1), .weightChanged(let weight2)):
                return weight1 == weight2
            case (.heightChanged(let height1), .heightChanged(let height2)):
                return height1 == height2
            case (.hairColorChanged(let title1, let checked1), .hairColorChanged(let title2, let checked2)):
                return title1 == title2 && checked1 == checked2
            case (.professionChanged(let title1, let checked1), .professionChanged(let title2, let checked2)):
                return title1 == title2 && checked1 == checked2
            case (.friendsChanged(let friends1), .friendsChanged(let friends2)):
                return friends1 == friends2
            default:
                return false
            }
        }
    }
}
