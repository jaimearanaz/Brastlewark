import Foundation

@testable import Domain

final class CharactersRepositoryMock: CharactersRepositoryProtocol {
    // MARK: - getAllCharacters
    var getAllCharactersResult: [Character] = []
    var getAllCharactersError: Error?
    var getAllCharactersCalled = false
    func getAllCharacters(forceUpdate: Bool) async throws -> [Character] {
        getAllCharactersCalled = true
        if let error = getAllCharactersError {
            throw error
        }
        return getAllCharactersResult
    }

    // MARK: - saveSelectedCharacter
    var saveSelectedCharacterCalled = false
    var savedCharacterId: Int?
    var saveSelectedCharacterError: Error?
    func saveSelectedCharacter(id: Int) async throws {
        saveSelectedCharacterCalled = true
        savedCharacterId = id
        if let error = saveSelectedCharacterError {
            throw error
        }
    }

    // MARK: - getSelectedCharacter
    var getSelectedCharacterResult: Int?
    var getSelectedCharacterError: Error?
    var getSelectedCharacterCalled = false
    func getSelectedCharacter() async throws -> Int? {
        getSelectedCharacterCalled = true
        if let error = getSelectedCharacterError {
            throw error
        }
        return getSelectedCharacterResult
    }

    // MARK: - deleteSelectedCharacter
    var deleteSelectedCharacterCalled = false
    var deleteSelectedCharacterError: Error?
    func deleteSelectedCharacter() async throws {
        deleteSelectedCharacterCalled = true
        if let error = deleteSelectedCharacterError {
            throw error
        }
    }
}
