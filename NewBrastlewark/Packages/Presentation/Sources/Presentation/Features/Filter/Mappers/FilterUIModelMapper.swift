import Domain

extension FilterUIModel {
    static func map(model: FilterUIModel) -> Filter {
        Filter(
            age: model.age.active.lowerBound...model.age.active.upperBound,
            weight: model.weight.active.lowerBound...model.weight.active.upperBound,
            height: model.height.active.lowerBound...model.height.active.upperBound,
            hairColor: Set<String>(model.hairColor.filter { $0.checked }.map { $0.title }),
            profession: Set<String>(model.profession.filter { $0.checked }.map { $0.title }),
            friends: model.friends.active.lowerBound...model.friends.active.upperBound)
    }
}
