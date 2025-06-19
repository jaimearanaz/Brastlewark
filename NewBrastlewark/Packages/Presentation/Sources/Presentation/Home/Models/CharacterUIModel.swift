import Foundation

struct CharacterUIModel: Identifiable {
    let id: Int
    let name: String
    let thumbnail: String
    let profession: String
    let age: Int
    let weight: Double
    let height: Double
    let hairColor: String
    let friends: [String]

    init(id: Int,
         name: String,
         thumbnail: String,
         profession: String,
         age: Int,
         weight: Double,
         height: Double,
         hairColor: String,
         friends: [String]) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.profession = profession
        self.age = age
        self.weight = weight
        self.height = height
        self.hairColor = hairColor
        self.friends = friends
    }
}
