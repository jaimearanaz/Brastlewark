import Foundation

@testable import Domain

final class CharactersRepositoryMock: CharactersRepositoryProtocol {
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

    var saveSelectedCharacterCalled = false
    var savedCharacter: Character?
    var saveSelectedCharacterError: Error?
    func saveSelectedCharacter(_ character: Character) async throws {
        saveSelectedCharacterCalled = true
        savedCharacter = character
        if let error = saveSelectedCharacterError {
            throw error
        }
    }

    var getSelectedCharacterResult: Character?
    var getSelectedCharacterError: Error?
    var getSelectedCharacterCalled = false
    func getSelectedCharacter() async throws -> Character? {
        getSelectedCharacterCalled = true
        if let error = getSelectedCharacterError {
            throw error
        }
        return getSelectedCharacterResult
    }

    var deleteSelectedCharacterCalled = false
    var deleteSelectedCharacterError: Error?
    func deleteSelectedCharacter() async throws {
        deleteSelectedCharacterCalled = true
        if let error = deleteSelectedCharacterError {
            throw error
        }
    }
}
