import Data
import Domain
import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    private let charactersRepository: CharactersRepositoryProtocol
    private let filterRepository: FilterRepositoryProtocol

    init() {
        guard let filterRepo = DIContainer.shared.resolve(FilterRepositoryProtocol.self),
             let charactersRepo = DIContainer.shared.resolve(CharactersRepositoryProtocol.self) else {
                 fatalError("Could not resolve dependencies")
        }
        self.charactersRepository = charactersRepo
        self.filterRepository = filterRepo
    }

    func fetchCharacters(forceUpdate: Bool) async {
        do {
            let result = try await charactersRepository.getCharacters(forceUpdate: forceUpdate)
            self.characters = result
            let filter = try await filterRepository.getAvailableFilter(fromCharacters: result)
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
