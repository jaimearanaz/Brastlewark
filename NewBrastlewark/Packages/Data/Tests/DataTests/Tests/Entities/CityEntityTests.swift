import Foundation
import Testing

@testable import Data

final class CityEntityTests {
    @Test
    func given_invalidCharacters_when_decoded_then_onlyValidCharactersAreReturned() throws {
        // given
        let json = """
        {
            "Brastlewark": [
                {
                    "id": 1,
                    "name": "Valid One",
                    "thumbnail": "one.png",
                    "age": 25,
                    "weight": 70.5,
                    "height": 120.0,
                    "hair_color": "Red",
                    "professions": ["Carpenter"],
                    "friends": []
                },
                {
                    "id": 2,
                    "name": "Missing Age",
                    "thumbnail": "two.png",
                    "weight": 80.0,
                    "height": 125.0,
                    "hair_color": "Black",
                    "professions": ["Miner"],
                    "friends": []
                },
                {
                    "id": "invalid id",
                    "name": "Invalid Type",
                    "thumbnail": "three.png",
                    "age": 30,
                    "weight": 75.0,
                    "height": 123.0,
                    "hair_color": "Brown",
                    "professions": ["Farmer"],
                    "friends": []
                },
                {
                    "id": 4,
                    "name": "Valid Two",
                    "thumbnail": "four.png",
                    "age": 40,
                    "weight": 90.0,
                    "height": 130.0,
                    "hair_color": "Green",
                    "professions": ["Brewer"],
                    "friends": ["Valid One"]
                }
            ]
        }
        """
        let data = try #require(json.data(using: .utf8))

        // when
        let city = try JSONDecoder().decode(CityEntity.self, from: data)

        // then
        #expect(city.brastlewark.map(\.id) == [1, 4])
        #expect(city.brastlewark.map(\.name) == ["Valid One", "Valid Two"])
    }
}
