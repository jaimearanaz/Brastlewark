import Domain

extension CharacterUIModel {
    static func map(model: CharacterUIModel) -> Character {
        .init(
            id: model.id,
            name: model.name,
            thumbnail: model.thumbnail,
            age: model.age,
            weight: model.weight,
            height: model.height,
            hairColor: model.hairColor,
            professions: model.professions,
            friends: model.friends)
    }
}
