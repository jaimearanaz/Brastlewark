import Foundation

public struct CharacterUIModel: Identifiable, Sendable, NameSplitting {
    public let id: Int
    public let name: String
    let thumbnail: String
    let age: Int
    let weight: Double
    let height: Double
    let hairColor: String
    let professions: [String]
    let friends: [String]
}
