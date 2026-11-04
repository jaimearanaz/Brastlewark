public enum CharactersRepositoryError: Error, Sendable {
    case noInternetConnection
    case unableToFetchCharacters
}

public protocol CharactersRepositoryProtocol: Sendable {
    func getAllCharacters(forceUpdate: Bool) async throws -> [Character]
}
