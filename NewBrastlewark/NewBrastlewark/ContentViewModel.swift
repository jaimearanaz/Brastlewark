import Data
import Domain
import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    private let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol
    private let getAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol
    private let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol

    init() {
        guard let getAllCharactersUseCase = DIContainer.shared.resolve(GetAllCharactersUseCaseProtocol.self),
                let getAvailableFilterUseCase = DIContainer.shared.resolve(GetAvailableFilterUseCaseProtocol.self),
             let getFilteredCharactersUseCase = DIContainer.shared.resolve(GetFilteredCharactersUseCaseProtocol.self) else {
                 fatalError("Could not resolve dependencies")
        }
        self.getAllCharactersUseCase = getAllCharactersUseCase
        self.getAvailableFilterUseCase = getAvailableFilterUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
    }

    func fetchCharacters(forceUpdate: Bool) async {
        let result = await getAllCharactersUseCase.execute(params: .init(forceUpdate: forceUpdate))
        switch result {
        case .success(let characters):
            self.characters = characters
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    func filterCharacters() async {
        let result = await getAvailableFilterUseCase.execute()
        switch result {
        case .success(let filterAvailable):
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
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
