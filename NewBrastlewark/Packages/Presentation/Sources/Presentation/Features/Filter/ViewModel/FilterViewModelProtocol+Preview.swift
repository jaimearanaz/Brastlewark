import Foundation
import Domain

extension FilterViewModelProtocol {
    static var noFilterActive: FilterViewModelMock {
        FilterViewModelMock(state: .ready(FilterUIModel(
            available: OneFilterUIModel(
                age: 50...100,
                weight: 30...50,
                height: 60...100,
                hairColor: ["Red", "Blue"],
                profession: ["Baker", "Carpenter"],
                friends: 1...5),
            active: OneFilterUIModel(
                age: 50...100,
                weight: 30...50,
                height: 60...100,
                hairColor: ["Red", "Blue"],
                profession: ["Baker", "Carpenter"],
                friends: 1...5)))
        )
    }

    static var filterActive: FilterViewModelMock {
        FilterViewModelMock(state: .ready(FilterUIModel(
            available: OneFilterUIModel(
                age: 50...100,
                weight: 30...50,
                height: 60...100,
                hairColor: ["Red", "Blue"],
                profession: ["Baker", "Carpenter"],
                friends: 1...5),
            active: OneFilterUIModel(
                age: 60...65,
                weight: 30...40,
                height: 80...100,
                hairColor: ["Red"],
                profession: ["Carpenter"],
                friends: 1...5)))
        )
    }
}
