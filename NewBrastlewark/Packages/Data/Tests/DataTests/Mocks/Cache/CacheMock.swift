import Foundation
@testable import Data

final class CacheMock: CharactersCacheProtocol {
    var storedCharacters: [CharacterEntity]?
    var valid = false
    var clearCalled = false
    var saveCalled = false

    func get() async -> [CharacterEntity]? {
        return storedCharacters
    }

    func save(_ characters: [CharacterEntity]) async {
        storedCharacters = characters
        saveCalled = true
    }

    func isValid() async -> Bool {
        return valid
    }

    func clearCache() async {
        clearCalled = true
        storedCharacters = nil
        valid = false
    }
}
