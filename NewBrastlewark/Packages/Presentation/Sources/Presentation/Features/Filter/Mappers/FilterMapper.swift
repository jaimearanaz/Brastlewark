import Foundation
import Domain

struct FilterMapper {
    static func map(model: Filter) -> OneFilterUIModel {
        OneFilterUIModel(
            age: model.age,
            weight: model.weight,
            height: model.height,
            hairColor: model.hairColor,
            profession: model.profession,
            friends: model.friends)
    }
}

