import Foundation

public protocol CharactersRepositoryProtocol {
    func getCharacters() async throws -> [Character]
}
