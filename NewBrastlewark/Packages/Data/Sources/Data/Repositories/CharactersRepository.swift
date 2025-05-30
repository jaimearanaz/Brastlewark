import Combine
import Domain
import Foundation

class CharactersRepository: CharactersRepositoryProtocol {
    private let networkService: NetworkServiceProtocol?

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getCharacters() async throws -> [Character] {
        try await withCheckedThrowingContinuation { continuation in
            guard let networkService = networkService else {
                continuation.resume(
                    throwing: NSError(
                        domain: "CharactersRepository",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "NetworkService is nil"]
                    )
                )
                return
            }

            var cancellable: AnyCancellable?
            cancellable = networkService.getCharacters()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                    cancellable = nil
                }, receiveValue: { characterEntities in
                    let characters = characterEntities.map { CharacterEntityMapper.map(entity: $0) }
                    continuation.resume(returning: characters)
                    cancellable = nil
                })
        }
    }
}
