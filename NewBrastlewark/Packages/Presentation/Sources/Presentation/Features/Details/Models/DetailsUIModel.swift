public struct DetailsUIModel: Sendable, NameSplitting {
    public let name: String
    let thumbnail: String
    let age: Int
    let weight: Double
    let height: Double
    let hairColor: String
    let professions: [String]
    let friends: [DetailsFriendUIModel]

    public init(
        name: String = "",
        thumbnail: String = "",
        age: Int = 0,
        weight: Double = 0.0,
        height: Double = 0.0,
        hairColor: String = "",
        professions: [String] = [],
        friends: [DetailsFriendUIModel] = []) {
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

public struct DetailsFriendUIModel: Sendable, NameSplitting {
    let id: Int
    public let name: String
    let thumbnail: String

    public init(
        id: Int = 0,
        name: String = "",
        thumbnail: String = "") {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}
