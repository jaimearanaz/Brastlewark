public enum CharactersRepositoryError: Error {
    case noInternetConnection
    case unableToFetchCharacters
    case unableToSaveSelectedCharacter
    case unableToGetSelectedCharacter
    case unableToDeleteSelectedCharacter
}

public protocol CharactersRepositoryProtocol {
    func getAllCharacters(forceUpdate: Bool) async throws -> [Character]
    func saveSelectedCharacter(_ character: Character) async throws
    func getSelectedCharacter() async throws -> Character?
    func deleteSelectedCharacter() async throws
}
