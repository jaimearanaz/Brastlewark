import Foundation

protocol CharactersCacheProtocol {
    func get() -> [CharacterEntity]?
    func save(_ characters: [CharacterEntity])
    func isValid() -> Bool
}

final class NonPersistentCharactersCache: CharactersCacheProtocol {
    private var characters: [CharacterEntity]?
    private var timestamp: Date?
    private var cacheValidity: TimeInterval

    init(cacheValidityInSeconds: TimeInterval = 10) {
        self.cacheValidity = cacheValidityInSeconds
    }

    func get() -> [CharacterEntity]? {
        return characters
    }

    func save(_ characters: [CharacterEntity]) {
        self.characters = characters
        self.timestamp = Date()
    }

    func isValid() -> Bool {
        guard let characters = characters, !characters.isEmpty,
              let timestamp = timestamp else { return false }
        return Date().timeIntervalSince(timestamp) < cacheValidity
    }
}
