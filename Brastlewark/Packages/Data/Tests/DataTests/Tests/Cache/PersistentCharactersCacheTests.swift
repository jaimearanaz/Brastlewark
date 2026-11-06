import Foundation
import SwiftData
import Testing

@testable import Data

@Suite(.serialized)
struct PersistentCharactersCacheTests {
    private var sut: CharactersCacheProtocol!

    init() {
        self.sut = makeInMemoryCache()
    }

    @Test
    func given_emptyCache_when_get_then_returnsNil() async {
        // given
        await sut.clearCache()

        // when
        let result = await sut.get()

        // then
        #expect(result == nil)
    }

    @Test
    func given_characterSaved_when_get_then_returnsSavedCharacter() async throws {
        // given
        let cache = makeInMemoryCache()
        await cache.clearCache()
        let character = try loadOneCharacterFromJSON()

        // when
        await cache.save([character])
        let result = await cache.get()

        // then
        #expect(result?.count == 1)
        #expect(result?.first?.id == character.id)
    }

    @Test
    func given_emptyCache_when_isValid_then_returnsFalse() async {
        // given
        let cache = makeInMemoryCache()
        await cache.clearCache()

        // when
        let valid = await cache.isValid()

        // then
        #expect(valid == false)
    }

    @Test
    func given_recentlySavedCharacter_when_isValid_then_returnsTrue() async throws {
        // given
        let cache = makeInMemoryCache()
        await cache.clearCache()
        let character = try loadOneCharacterFromJSON()

        // when
        await cache.save([character])
        let valid = await cache.isValid()

        // then
        #expect(valid == true)
    }

    @Test
    func given_oldTimestamp_when_isValid_then_returnsFalse() async throws {
        // given
        let cache = makeInMemoryCache()
        await cache.clearCache()
        let character = try loadOneCharacterFromJSON()

        // when
        await cache.save([character])
        let oldDate = Date(timeIntervalSinceNow: -1000)
        UserDefaults.standard.set(oldDate, forKey: "characters_cache_timestamp")
        let valid = await cache.isValid()

        // then
        #expect(valid == false)
    }

    @Test
    func given_savedCharacter_when_clearCache_then_removesContentAndInvalidatesCache() async throws {
        // given
        let cache = makeInMemoryCache()
        await cache.save([try loadOneCharacterFromJSON()])

        // when
        await cache.clearCache()

        // then
        #expect(await cache.get() == nil)
        #expect(await cache.isValid() == false)
    }

    @Test
    func given_existingCharacter_when_savingNewCharacter_then_replacesContent() async {
        // given
        let cache = makeInMemoryCache()
        await cache.save([makeCharacter(id: 1)])

        // when
        await cache.save([makeCharacter(id: 2)])
        let result = await cache.get()

        // then
        #expect(result?.map(\.id) == [2])
    }

    @Test
    func given_existingCharacter_when_savingEmptyArray_then_emptiesAndInvalidatesCache() async {
        // given
        let cache = makeInMemoryCache()
        await cache.save([makeCharacter(id: 1)])

        // when
        await cache.save([])

        // then
        #expect(await cache.get() == nil)
        #expect(await cache.isValid() == false)
    }

    @Test
    func given_characterWithAllFields_when_savedAndRetrieved_then_preservesEveryField() async throws {
        // given
        let cache = makeInMemoryCache()
        let character = try loadOneCharacterFromJSON()

        // when
        await cache.save([character])
        let result = await cache.get()?.first

        // then
        let retrieved = try #require(result)
        expectEqual(retrieved, character)
    }

    @Test
    func given_multipleCharacters_when_saved_then_retrievesAllCharacters() async {
        // given
        let cache = makeInMemoryCache()
        let characters = (1...3).map(makeCharacter(id:))

        // when
        await cache.save(characters)
        let result = await cache.get()

        // then
        #expect(result?.count == characters.count)
        #expect(Set(result?.map(\.id) ?? []) == Set(characters.map(\.id)))
    }

    @Test
    func given_timestampWithinValidityWindow_when_isValid_then_returnsTrue() async {
        // given
        let cache = makeInMemoryCache(cacheValidityInSeconds: 60)
        await cache.save([makeCharacter(id: 1)])
        UserDefaults.standard.set(Date(timeIntervalSinceNow: -30), forKey: cacheTimestampKey)

        // when
        let valid = await cache.isValid()

        // then
        #expect(valid == true)
    }

    @Test
    func given_savedContentWithoutTimestamp_when_isValid_then_returnsFalse() async {
        // given
        let cache = makeInMemoryCache()
        await cache.save([makeCharacter(id: 1)])
        UserDefaults.standard.removeObject(forKey: cacheTimestampKey)

        // when
        let valid = await cache.isValid()

        // then
        #expect(valid == false)
    }

    @Test
    func given_twoDifferentContainers_when_savingInOne_then_otherRemainsEmpty() async {
        // given
        let firstCache = makeInMemoryCache()
        let secondCache = makeInMemoryCache()

        // when
        await firstCache.save([makeCharacter(id: 1)])

        // then
        #expect(await firstCache.get()?.map(\.id) == [1])
        #expect(await secondCache.get() == nil)
    }

    @Test
    func given_twoCachesSharingContainer_when_oneSaves_then_otherCanRead() async {
        // given
        let container = makeInMemoryContainer()
        let firstCache = makeInMemoryCache(modelContainer: container)
        let secondCache = makeInMemoryCache(modelContainer: container)

        // when
        await firstCache.save([makeCharacter(id: 1)])

        // then
        #expect(await secondCache.get()?.map(\.id) == [1])
    }

    @Test
    func given_concurrentReadsAndWrites_when_completed_then_neverReturnsPartialContent() async {
        // given
        let cache = makeInMemoryCache()

        // when
        await withTaskGroup(of: Void.self) { group in
            for id in 1...10 {
                group.addTask {
                    let characters = [self.makeCharacter(id: id), self.makeCharacter(id: id + 100)]
                    await cache.save(characters)
                    let result = await cache.get()

                    // then
                    #expect(result?.count == characters.count)
                }
            }
        }

        let finalResult = await cache.get()
        #expect(finalResult?.count == 2)
    }
}

// swiftlint:disable force_try force_unwrapping
private extension PersistentCharactersCacheTests {
    var cacheTimestampKey: String { "characters_cache_timestamp" }

    func makeInMemoryContainer() -> ModelContainer {
        try! ModelContainer(
            for: CharacterModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    func makeInMemoryCache(
        cacheValidityInSeconds: TimeInterval = 10,
        modelContainer: ModelContainer? = nil
    ) -> PersistentCharactersCache {
        PersistentCharactersCache(
            cacheValidityInSeconds: cacheValidityInSeconds,
            modelContainer: modelContainer ?? makeInMemoryContainer()
        )!
    }

    func makeCharacter(id: Int) -> CharacterEntity {
        CharacterEntity(
            id: id,
            name: "Character \(id)",
            thumbnail: "https://example.com/\(id).png",
            age: 20 + id,
            weight: 60 + Double(id),
            height: 100 + Double(id),
            hairColor: "Red",
            professions: ["Tester", "Developer"],
            friends: ["Friend \(id)"]
        )
    }

    func expectEqual(_ lhs: CharacterEntity, _ rhs: CharacterEntity) {
        #expect(lhs.id == rhs.id)
        #expect(lhs.name == rhs.name)
        #expect(lhs.thumbnail == rhs.thumbnail)
        #expect(lhs.age == rhs.age)
        #expect(lhs.weight == rhs.weight)
        #expect(lhs.height == rhs.height)
        #expect(lhs.hairColor == rhs.hairColor)
        #expect(lhs.professions == rhs.professions)
        #expect(lhs.friends == rhs.friends)
    }
}
// swiftlint:enable force_try force_unwrapping
