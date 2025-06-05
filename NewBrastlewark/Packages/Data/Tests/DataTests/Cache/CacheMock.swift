@testable import Data

class MockCache: CharactersCacheProtocol {
    var characters: [CharacterEntity]? = nil
    var valid: Bool = false
    func get() -> [CharacterEntity]? { characters }
    func save(_ characters: [CharacterEntity]) { self.characters = characters }
    func isValid() -> Bool { valid }
}
