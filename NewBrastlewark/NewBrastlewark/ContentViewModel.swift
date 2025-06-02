import Data
import Domain
import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    private let repository: CharactersRepositoryProtocol

    init() {
        if let repository = DIContainer.shared.resolve(CharactersRepositoryProtocol.self) {
            self.repository = repository
        } else {
            fatalError("Could not resolve CharactersRepositoryProtocol")
        }
    }

    func fetchCharacters(forceUpdate: Bool) async {
        do {
            let result = try await repository.getCharacters(forceUpdate: forceUpdate)
            self.characters = result
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
