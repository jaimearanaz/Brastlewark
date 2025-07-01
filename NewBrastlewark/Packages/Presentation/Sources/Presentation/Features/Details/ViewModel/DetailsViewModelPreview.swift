import Foundation
import Domain

@MainActor
enum DetailsViewModelPreview {
    static var ready: some DetailsViewModelProtocol & ObservableObject {
        DetailsViewModelMock(state: .ready(details:
                .init(
                    name: "Gandalf the Grey",
                    thumbnail: "https://example.com/gandalf.jpg",
                    age: 320,
                    weight: 67.4,
                    height: 50.9,
                    hairColor: "White",
                    professions: ["Wizard", "Leader of the Fellowship"],
                    friends: [
                        .init(
                            id: 1,
                            name: "Frodo Baggins",
                            thumbnail: "https://example.com/frodo.jpg"),
                        .init(
                            id: 2,
                            name: "Bilbo Baggins",
                            thumbnail: "https://example.com/bilbo.jpg")
                    ])))
    }

    static var noFriends: some DetailsViewModelProtocol & ObservableObject {
        DetailsViewModelMock(state: .ready(details:
                .init(
                    name: "Gandalf the Grey",
                    thumbnail: "https://example.com/gandalf.jpg",
                    age: 320,
                    weight: 67.4,
                    height: 50.9,
                    hairColor: "White",
                    professions: ["Wizard", "Leader of the Fellowship"],
                    friends: [])))
    }
}
