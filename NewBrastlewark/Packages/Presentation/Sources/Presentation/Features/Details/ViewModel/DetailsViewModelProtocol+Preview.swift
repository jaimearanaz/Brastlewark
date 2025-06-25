import Foundation
import Domain

extension DetailsViewModelProtocol {
    static var ready: DetailsViewModelMock {
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
}

