public struct DetailsUIModel {
    let name: String
    let thumbnail: String
    let age: Int
    let weight: Double
    let height: Double
    let hairColor: String
    let professions: [String]

    public init(
        name: String = "",
        thumbnail: String = "",
        age: Int = 0,
        weight: Double = 0.0,
        height: Double = 0.0,
        hairColor: String = "",
        professions: [String] = []) {
        self.name = name
        self.thumbnail = thumbnail
        self.age = age
        self.weight = weight
        self.height = height
        self.hairColor = hairColor
        self.professions = professions
    }
}
