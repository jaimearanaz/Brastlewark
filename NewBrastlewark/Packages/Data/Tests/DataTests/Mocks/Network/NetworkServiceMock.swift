import Combine

@testable import Data

class NetworkServiceMock: NetworkServiceProtocol {
    var error: NetworkErrors?
    var result: [CharacterEntity]?

    // swiftlint:disable force_unwrapping
    func getCharacters() async throws -> [CharacterEntity] {
        guard error == nil else {
            throw error!
        }

        guard let result = result else {
            throw NetworkErrors.general
        }
        return result
    }
    // swiftlint:enable force_unwrapping
}
