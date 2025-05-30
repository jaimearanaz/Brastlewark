struct CityEntity: Codable {
    var brastlewark: [CharacterEntity]

    enum CodingKeys: String, CodingKey {
        case brastlewark = "Brastlewark"
    }
}
