import Domain

extension Filter {
    static func map(available: Filter, active: Filter) -> FilterUIModel {
        return .init(
            age: .init(
                available: available.age.lowerBound...available.age.upperBound,
                active: active.age.lowerBound...active.age.upperBound),
            weight: .init(
                available: available.weight.lowerBound...available.weight.upperBound,
                active: active.weight.lowerBound...active.weight.upperBound),
            height: .init(
                available: available.height.lowerBound...available.height.upperBound,
                active: active.height.lowerBound...active.height.upperBound),
            hairColor: mapHairColor(available: available, active: active),
            profession: mapProfession(available: available, active: active),
            friends: .init(
                available: available.friends.lowerBound...available.friends.upperBound,
                active: active.friends.lowerBound...active.friends.upperBound)
        )
    }
}

private extension Filter {
    static func mapHairColor(available: Filter, active: Filter) -> [FilterItemListUIModel] {
        let availableHairColors = Set(available.hairColor)
        let activeHairColors = Set(active.hairColor)
        return availableHairColors.map { color in
            FilterItemListUIModel(
                title: color,
                checked: activeHairColors.contains(color)
            )
        }
    }

    static func mapProfession(available: Filter, active: Filter) -> [FilterItemListUIModel] {
        let availableProfession = Set(available.profession)
        let activeProfession = Set(active.profession)
        return availableProfession.map { profession in
            FilterItemListUIModel(
                title: profession,
                checked: activeProfession.contains(profession)
            )
        }
    }
}
