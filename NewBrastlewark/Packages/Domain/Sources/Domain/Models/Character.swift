public struct Character: Codable, Sendable {
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
}
