import Foundation
import Testing

@testable import Data

struct NonPersistentCharactersCacheTests {
    @Test
    func given_emptyCache_when_get_then_returnsNil() {
        let cache = NonPersistentCharactersCache()
        #expect(cache.get() == nil)
    }

    @Test
    func given_cacheWithCharacters_when_saveAndGet_then_returnsSavedCharacters() {
        let cache = NonPersistentCharactersCache()
        let characters = [CharacterEntity.mock()]
        cache.save(characters)
        #expect(cache.get()?.count == 1)
        #expect(cache.get()?.first?.id == characters.first?.id)
    }

    @Test
    func given_emptyCache_when_isValid_then_returnsFalse() {
        let cache = NonPersistentCharactersCache()
        #expect(!cache.isValid())
    }

    @Test
    func given_cacheWithCharacters_when_saveAndCheckValidityWithinTime_then_returnsTrue() {
        let cache = NonPersistentCharactersCache(cacheValidityInSeconds: 2)
        let characters = [CharacterEntity.mock()]
        cache.save(characters)
        #expect(cache.isValid())
    }

    @Test
    func given_cacheWithCharacters_when_validityExpires_then_returnsFalse() {
        let cache = NonPersistentCharactersCache(cacheValidityInSeconds: 0.1)
        let characters = [CharacterEntity.mock()]
        cache.save(characters)
        sleep(1)
        #expect(!cache.isValid())
    }

    @Test
    func given_cacheWithEmptyArray_when_save_then_isValidReturnsFalse() {
        let cache = NonPersistentCharactersCache()
        cache.save([])
        #expect(!cache.isValid())
    }
}
