import Domain
import Foundation
import Testing

@testable import Data

struct FilterRepositoryTests {
    private var sut: FilterRepositoryProtocol!
    
    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(FilterRepositoryProtocol.self)! as! FilterRepository
    }

    @Test
    func given_characters_when_getAvailableFilter_then_returnsCorrectFilter() async throws {
        // given
        let characters = try loadCharactersFromJSON().map { CharacterEntityMapper.map(entity: $0) }

        // when
        let filter = try await sut.getAvailableFilter(fromCharacters: characters)

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
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)

        // when
        try await sut.saveActiveFilter(filter)
        let result = try await sut.getActiveFilter()

        // then
        #expect(result == filter)
    }

    @Test
    func when_saveActiveFilter_and_deleteActiveFilter_then_getActiveFilterReturnsNil() async throws {
        // given
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)

        // when
        try await sut.saveActiveFilter(filter)
        try await sut.deleteActiveFilter()
        let result = try await sut.getActiveFilter()

        // then
        #expect(result == nil)
    }

    @Test
    func given_emptyCharacters_when_getAvailableFilter_then_returnsZeroRangesAndSets() async throws {
        // given
        let characters: [Character] = []

        // when
        let filter = try await sut.getAvailableFilter(fromCharacters: characters)

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
