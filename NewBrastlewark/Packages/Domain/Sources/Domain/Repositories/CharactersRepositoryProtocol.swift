import Foundation

public protocol CharactersRepositoryProtocol {
    func getAllCharacters(forceUpdate: Bool) async throws -> [Character]
    func saveSelectedCharacter(_ character: Character) async throws
    func getSelectedCharacter() async throws -> Character?
    func deleteSelectedCharacter() async throws
}
