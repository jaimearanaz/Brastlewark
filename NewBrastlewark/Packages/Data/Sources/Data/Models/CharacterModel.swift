import Foundation
import SwiftData

@Model
final class CharacterModel {
    @Attribute(.unique)
    var id: Int
    var name: String
    var thumbnail: String
    var age: Int
    var weight: Double
    var height: Double
    var hairColor: String
    var professions: [String]
    var friends: [String]

    init(
        id: Int,
        name: String,
        thumbnail: String,
        age: Int,
        weight: Double,
        height: Double,
        hairColor: String,
        professions: [String],
        friends: [String]) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.age = age
        self.weight = weight
        self.height = height
        self.hairColor = hairColor
        self.professions = professions
        self.friends = friends
    }
}

extension CharacterModel {
    func toCharacterEntity() -> CharacterEntity {
        CharacterEntity(
            id: id,
            name: name,
            thumbnail: thumbnail,
            age: age,
            weight: weight,
            height: height,
            hairColor: hairColor,
            professions: professions,
            friends: friends
        )
    }
}
