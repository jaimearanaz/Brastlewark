@testable import Data

actor NetworkServiceMock: NetworkServiceProtocol {
    private var error: NetworkErrors?
    private var result: [CharacterEntity]?

    func configure(error: NetworkErrors? = nil, result: [CharacterEntity]? = nil) {
        self.error = error
        self.result = result
    }

    func getCharacters() async throws -> [CharacterEntity] {
        if let error {
            throw error
        }

        guard let result else {
            throw NetworkErrors.general
        }
        return result
    }
}
