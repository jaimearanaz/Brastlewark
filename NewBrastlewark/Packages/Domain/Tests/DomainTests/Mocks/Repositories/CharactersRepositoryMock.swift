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
}
