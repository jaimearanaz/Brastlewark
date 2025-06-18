import Combine
import Domain
import Foundation

protocol HomeViewModelProtocol {
    // Outputs
    var characters: [CharacterUIModel] { get }
    var isLoading: Bool { get }
    var searchText: String { get set }

    // Inputs
    func didViewLoad()
    func didSelectCharacter(_ character: CharacterUIModel)
    func didTapFilterButton()
    func didTapResetButton()
}

final public class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published private(set) var characters: [CharacterUIModel] = []
    @Published private(set) var isLoading = false
    @Published var searchText = ""

    // MARK: - Use Cases
    private let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol
    private let saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol
    private let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol
    private let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol
    private let deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol
    private let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol

    // MARK: - Initializer
    public init(
        getAllCharactersUseCase: GetAllCharactersUseCaseProtocol,
        saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol,
        getActiveFilterUseCase: GetActiveFilterUseCaseProtocol,
        getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol,
        deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol,
        getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol
    ) {
        self.getAllCharactersUseCase = getAllCharactersUseCase
        self.saveSelectedCharacterUseCase = saveSelectedCharacterUseCase
        self.getActiveFilterUseCase = getActiveFilterUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
        self.deleteActiveFilterUseCase = deleteActiveFilterUseCase
        self.getSearchedCharacterUseCase = getSearchedCharacterUseCase
    }

    func didViewLoad() {
        isLoading = true
        defer { isLoading = false }
        do {
            self.characters = try loadCharactersFromJSON().map { CharacterMapper.map(model: $0) }
        } catch {
            self.characters = []
        }
//        let useCase = getAllCharactersUseCase
//        Task {
//            let result = await useCase.execute(params: .init(forceUpdate: false))
//            switch result {
//            case .success(let characters):
//                self.characters = CharacterMapper.map(models: characters)
//            case .failure:
//                // TODO: Handle error, show alert, etc.
//                self.characters = []
//            }
//        }
    }

    func didSelectCharacter(_ character: CharacterUIModel) {
        // Implementation pending
    }

    func didTapFilterButton() {
        // Implementation pending
    }

    func didTapResetButton() {
        didViewLoad()
    }
}
