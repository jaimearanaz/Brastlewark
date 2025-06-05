import Combine

@testable import Data

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<[CharacterEntity], Error>?
    func getCharacters() -> AnyPublisher<[CharacterEntity], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkErrors.general).eraseToAnyPublisher()
        }
    }
}
