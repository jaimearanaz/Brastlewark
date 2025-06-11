import Domain
import Foundation
import Testing

@testable import Data

struct FilterRepositoryTests {
    @Test
    func given_characters_when_getAvailableFilter_then_returnsCorrectFilter() async throws {
        // given
        let repo = FilterRepository()
        let characters = try loadCharactersFromJSON()

        // when
        let filter = try await repo.getAvailableFilter(fromCharacters: characters)

        // then
        #expect(filter.age.lowerBound == 166)
        #expect(filter.age.upperBound == 306)
        #expect(filter.weight.lowerBound == 35)
        #expect(filter.weight.upperBound == 39)
        #expect(filter.height.lowerBound == 106)
        #expect(filter.height.upperBound == 110)
        #expect(filter.hairColor.contains("Pink"))
        #expect(filter.hairColor.contains("Green"))
        #expect(filter.hairColor.contains("Red"))
        #expect(filter.profession.contains("Metalworker"))
        #expect(filter.profession.contains("Woodcarver"))
        #expect(filter.profession.contains("Stonecarver"))
        #expect(filter.profession.contains(" Tinker"))
        #expect(filter.profession.contains("Tailor"))
        #expect(filter.profession.contains("Potter"))
        #expect(filter.profession.contains("Brewer"))
        #expect(filter.profession.contains("Medic"))
        #expect(filter.profession.contains("Prospector"))
        #expect(filter.profession.contains("Gemcutter"))
        #expect(filter.profession.contains("Mason"))
        #expect(filter.profession.contains("Cook"))
        #expect(filter.profession.contains("Baker"))
        #expect(filter.profession.contains("Miner"))
        #expect(filter.friends.lowerBound == 0)
        #expect(filter.friends.upperBound == 2)
    }

    @Test
    func when_saveActiveFilter_and_getActiveFilter_then_returnsSavedFilter() async throws {
        // given
        let repo = FilterRepository()
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)

        // when
        try await repo.saveActiveFilter(filter)
        let result = try await repo.getActiveFilter()

        // then
        #expect(result == filter)
    }

    @Test
    func when_saveActiveFilter_and_deleteActiveFilter_then_getActiveFilterReturnsNil() async throws {
        // given
        let repo = FilterRepository()
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)

        // when
        try await repo.saveActiveFilter(filter)
        try await repo.deleteActiveFilter()
        let result = try await repo.getActiveFilter()

        // then
        #expect(result == nil)
    }

    @Test
    func given_emptyCharacters_when_getAvailableFilter_then_returnsZeroRangesAndSets() async throws {
        // given
        let repo = FilterRepository()
        let characters: [Character] = []

        // when
        let filter = try await repo.getAvailableFilter(fromCharacters: characters)

        // then
        #expect(filter.age.lowerBound == 0)
        #expect(filter.age.upperBound == 0)
        #expect(filter.weight.lowerBound == 0)
        #expect(filter.weight.upperBound == 0)
        #expect(filter.height.lowerBound == 0)
        #expect(filter.height.upperBound == 0)
        #expect(filter.hairColor.isEmpty)
        #expect(filter.profession.isEmpty)
        #expect(filter.friends.lowerBound == 0)
        #expect(filter.friends.upperBound == 0)
    }
}

private extension FilterRepositoryTests {
    func loadCharactersFromJSON() throws -> [Character] {
        let url = Bundle.module.url(forResource: "valid_characters", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder
            .decode(CityEntity.self, from: data)
            .brastlewark
            .map{ CharacterEntityMapper.map(entity: $0)}
    }
}
