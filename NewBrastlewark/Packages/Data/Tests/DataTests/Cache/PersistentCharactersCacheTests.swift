import Foundation
import SwiftData
import Testing

@testable import Data

struct PersistentCharactersCacheTests {
    @Test
    func given_emptyCache_when_get_then_returnsNil() async {
        // given
        let cache = makeInMemoryCache()
        await cache.clearCache()

        // when
        let result = await cache.get()

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
}

private extension PersistentCharactersCacheTests {
    func makeInMemoryCache() -> PersistentCharactersCache {
        let inMemoryContainer = try! ModelContainer(
            for: CharacterModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return PersistentCharactersCache(cacheValidityInSeconds: 10, modelContainer: inMemoryContainer)
    }
}
