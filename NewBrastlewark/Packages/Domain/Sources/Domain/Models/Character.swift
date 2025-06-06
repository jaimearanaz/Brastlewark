public struct Character: Codable, Sendable, Equatable {
    public let id: Int
    public let name: String
    public let thumbnail: String
    public let age: Int
    public let weight: Double
    public let height: Double
    public let hairColor: String
    public let professions: [String]
    public let friends: [String]

    public init(
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

    public static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.thumbnail == rhs.thumbnail &&
            lhs.age == rhs.age &&
            lhs.weight == rhs.weight &&
            lhs.height == rhs.height &&
            lhs.hairColor == rhs.hairColor &&
            lhs.professions == rhs.professions &&
            lhs.friends == rhs.friends
    }
}
