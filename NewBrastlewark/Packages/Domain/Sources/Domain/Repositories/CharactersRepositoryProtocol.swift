import Foundation

public protocol CharactersRepositoryProtocol {
    func getCharacters(forceUpdate: Bool) async throws -> [Character]
}
