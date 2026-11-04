@testable import Data

actor CacheMock: CharactersCacheProtocol {
    private var storedCharacters: [CharacterEntity]?
    private var valid = false
    private var clearCalled = false
    private var saveCalled = false

    func configure(storedCharacters: [CharacterEntity]? = nil, valid: Bool = false) {
        self.storedCharacters = storedCharacters
        self.valid = valid
    }

    func savedCharacters() -> [CharacterEntity]? {
        storedCharacters
    }

    func wasSaveCalled() -> Bool {
        saveCalled
    }

    func get() async -> [CharacterEntity]? {
        storedCharacters
    }

    func save(_ characters: [CharacterEntity]) async {
        storedCharacters = characters
        saveCalled = true
    }

    func isValid() async -> Bool {
        valid
    }

    func clearCache() async {
        clearCalled = true
        storedCharacters = nil
        valid = false
    }
}
