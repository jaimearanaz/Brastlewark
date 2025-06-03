import Data
import Domain
import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    private let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol
    private let charactersRepository: CharactersRepositoryProtocol
    private let filterRepository: FilterRepositoryProtocol

    init() {
        guard let filterRepo = DIContainer.shared.resolve(FilterRepositoryProtocol.self),
              let charactersRepo = DIContainer.shared.resolve(CharactersRepositoryProtocol.self),
             let getFilteredCharactersUseCase = DIContainer.shared.resolve(GetFilteredCharactersUseCaseProtocol.self) else {
                 fatalError("Could not resolve dependencies")
        }
        self.charactersRepository = charactersRepo
        self.filterRepository = filterRepo
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
    }

    func fetchCharacters(forceUpdate: Bool) async {
        do {
            let characters = try await charactersRepository.getAllCharacters(forceUpdate: forceUpdate)
            self.characters = characters
            let filter = try await filterRepository.getAvailableFilter(fromCharacters: characters)
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func filterCharacters() async {
        do {
            let characters = try await charactersRepository.getAllCharacters(forceUpdate: false)
            self.characters = characters
            let filterAvailable = try await filterRepository.getAvailableFilter(fromCharacters: characters)
            let filter = Filter(
                age: 30...100,
                weight: 35...40,
                height: 91...129,
                hairColor: filterAvailable.hairColor,
                profession: .init(arrayLiteral: "Mechanic"),
                friends: filterAvailable.friends)
            let result = await getFilteredCharactersUseCase.execute(params: .init(filter: filter))
            switch result {
            case .success(let filteredCharacters):
                self.characters = filteredCharacters
                self.errorMessage = nil
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
