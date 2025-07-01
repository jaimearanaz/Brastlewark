import Foundation
import Domain

@MainActor
enum FilterViewModelPreview {
    static var noFilterActive: some FilterViewModelProtocol & ObservableObject {
        FilterViewModelMock(state: .ready(
            .init(
                age: .init(
                    available: 50...100,
                    active: 50...100),
                weight: .init(
                    available: 30...50,
                    active: 30...50),
                height: .init(
                    available: 60...100,
                    active: 60...100),
                hairColor: [.init(title: "Red", checked: false), .init(title: "Blue", checked: false)],
                profession: [.init(title: "Baker", checked: false), .init(title: "Carpenter", checked: false)],
                friends: .init(
                    available: 1...5,
                    active: 1...5)
            )
        ))
    }

    static var filterActive: some FilterViewModelProtocol & ObservableObject {
        FilterViewModelMock(state: .ready(
            .init(
                age: .init(
                    available: 50...100,
                    active: 60...75),
                weight: .init(
                    available: 30...50,
                    active: 30...40),
                height: .init(
                    available: 60...100,
                    active: 80...100),
                hairColor: [.init(title: "Red", checked: true), .init(title: "Blue", checked: false)],
                profession: [.init(title: "Baker", checked: false), .init(title: "Carpenter", checked: true)],
                friends: .init(
                    available: 1...5,
                    active: 1...5)
            )
        ))
    }
}
