import Foundation
import Domain

struct CharacterMapper {
    static func map(model: Character) -> CharacterUIModel {
        CharacterUIModel(
            id: model.id,
            name: model.name,
            thumbnail: model.thumbnail,
            profession: model.professions.first ?? "Unknown",
            age: model.age,
            weight: model.weight,
            height: model.height,
            hairColor: model.hairColor,
            friends: model.friends
        )
    }
    
    static func map(models: [Character]) -> [CharacterUIModel] {
        models.map { map(model: $0) }
    }
}
