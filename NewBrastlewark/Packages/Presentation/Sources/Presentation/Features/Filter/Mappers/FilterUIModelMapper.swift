import Foundation
import Domain

extension FilterUIModel {
    static func map(model: OneFilterUIModel) -> Filter {
        Filter(
            age: model.age,
            weight: model.weight,
            height: model.height,
            hairColor: model.hairColor,
            profession: model.profession,
            friends: model.friends)
    }
}
