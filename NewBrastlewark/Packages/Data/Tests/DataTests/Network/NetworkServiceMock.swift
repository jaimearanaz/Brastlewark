import Combine

@testable import Data

class NetworkServiceMock: NetworkServiceProtocol {
    var error: NetworkErrors?
    var result: [CharacterEntity]?

    func getCharacters() async throws -> [CharacterEntity] {
        guard error == nil else {
            throw error!
        }

        guard let result = result else {
            throw NetworkErrors.general
        }
        return result
    }
}
