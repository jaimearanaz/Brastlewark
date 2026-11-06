private struct LossyDecodable<Value: Decodable>: Decodable {
    let value: Value?

    init(from decoder: Decoder) {
        value = try? Value(from: decoder)
    }
}

struct CityEntity: Codable {
    var brastlewark: [CharacterEntity]

    enum CodingKeys: String, CodingKey {
        case brastlewark = "Brastlewark"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let characters = try container.decode(
            [LossyDecodable<CharacterEntity>].self,
            forKey: .brastlewark
        )

        brastlewark = characters.compactMap(\.value)
    }
}
