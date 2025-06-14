import Combine
import Domain
import Foundation

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    // Outputs
    var characters: [CharacterUIModel] { get }
    var isLoading: Bool { get }
    var searchText: String { get set }

    // Inputs
    func didViewLoad() async
    func didSelectCharacter(_ character: CharacterUIModel) async
    func didTapFilterButton() async
    func didTapResetButton() async
}

@MainActor
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

    func didViewLoad() async {
        // Implementation pending
    }

    func didSelectCharacter(_ character: CharacterUIModel) async {
        // Implementation pending
    }

    func didTapFilterButton() async {
        // Implementation pending
    }

    func didTapResetButton() async {
        // Implementation pending
    }
}
