import Domain

struct CharacterEntityMapper {
    static func map(entity: CharacterEntity) -> Character {
        Character(
            id: entity.id,
            name: entity.name,
            thumbnail: entity.thumbnail,
            age: entity.age,
            weight: entity.weight,
            height: entity.height,
            hairColor: entity.hairColor,
            professions: entity.professions,
            friends: entity.friends)
    }
}
