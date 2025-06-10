import Foundation
import Testing
@testable import Data
import Domain

struct FilterRepositoryTests {
    @Test
    func given_characters_when_getAvailableFilter_then_returnsCorrectFilter() async {
        let repo = FilterRepository()
        let characters = makeCharacters()
        let filter = await repo.getAvailableFilter(fromCharacters: characters)
        #expect(filter.age.lowerBound == 20)
        #expect(filter.age.upperBound == 30)
        #expect(filter.weight.lowerBound == 50)
        #expect(filter.weight.upperBound == 70)
        #expect(filter.height.lowerBound == 150)
        #expect(filter.height.upperBound == 170)
        #expect(filter.hairColor.contains("Blonde"))
        #expect(filter.hairColor.contains("Brown"))
        #expect(filter.hairColor.contains("Red"))
        #expect(filter.profession.contains("Farmer"))
        #expect(filter.profession.contains("Miner"))
        #expect(filter.profession.contains("Builder"))
        #expect(filter.friends.lowerBound == 0)
        #expect(filter.friends.upperBound == 2)
    }

    @Test
    func when_saveActiveFilter_and_getActiveFilter_then_returnsSavedFilter() async throws {
        let repo = FilterRepository()
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)
        try await repo.saveActiveFilter(filter)
        let result = try await repo.getActiveFilter()
        #expect(result == filter)
    }

    @Test
    func when_saveActiveFilter_and_deleteActiveFilter_then_getActiveFilterReturnsNil() async throws {
        let repo = FilterRepository()
        let filter = Filter(
            age: 1...2,
            weight: 3...4,
            height: 5...6,
            hairColor: ["A"],
            profession: ["B"],
            friends: 7...8)
        try await repo.saveActiveFilter(filter)
        try await repo.deleteActiveFilter()
        let result = try await repo.getActiveFilter()
        #expect(result == nil)
    }

    @Test
    func given_emptyCharacters_when_getAvailableFilter_then_returnsZeroRangesAndSets() async {
        let repo = FilterRepository()
        let characters: [Character] = []
        let filter = await repo.getAvailableFilter(fromCharacters: characters)
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
    func makeCharacters() -> [Character] {
        return [
            Character(
                id: 1,
                name: "Alice",
                thumbnail: "",
                age: 20,
                weight: 50,
                height: 150,
                hairColor: "Blonde",
                professions: [
                    "Farmer",
                    "Miner"],
                friends: ["Bob"]),
            Character(
                id: 2,
                name: "Bob",
                thumbnail: "",
                age: 30,
                weight: 70,
                height: 170,
                hairColor: "Brown",
                professions: ["Builder"],
                friends: [
                    "Alice",
                    "Charlie"]),
            Character(
                id: 3,
                name: "Charlie",
                thumbnail: "",
                age: 25,
                weight: 60,
                height: 160,
                hairColor: "Red",
                professions: [],
                friends: [])
        ]
    }
}
