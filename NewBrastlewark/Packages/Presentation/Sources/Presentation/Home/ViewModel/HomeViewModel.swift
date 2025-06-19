import Combine
import Domain
import Foundation

@MainActor
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
    func didSearchTextChanged()
    func didRefreshCharacters()
}

@MainActor
final public class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published private(set) var characters: [CharacterUIModel] = []
    @Published private(set) var isLoading = false
    @Published var searchText = "" {
        didSet {
            didSearchTextChanged()
        }
    }

    private let minSearchChars = 3
    private var searchCancellable: AnyCancellable?
    
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
        setupSearchSubscription()
    }

    func didViewLoad() {
        loadAllCharacters()
    }

    func didSelectCharacter(_ character: CharacterUIModel) {
        // Implementation pending
    }

    func didTapFilterButton() {
        // Implementation pending
    }

    func didTapResetButton() {
        searchText = ""
        loadAllCharacters()
    }

    func didSearchTextChanged() {
        guard searchText.count >= minSearchChars else {
            loadAllCharacters()
            return
        }
        let useCase = getSearchedCharacterUseCase
        Task {
            let result = await useCase.execute(params: .init(searchText: searchText))
            switch result {
            case .success(let characters):
                self.characters = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
            case .failure:
                self.characters = []
            }
        }
    }

    func didRefreshCharacters() {
        searchText = ""
        loadAllCharacters(forceUpdate: true)
    }
}

private extension HomeViewModel {
    func setupSearchSubscription() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didSearchTextChanged()
            }
    }

    func loadAllCharacters(forceUpdate: Bool = false) {
        isLoading = true
        defer { isLoading = false }

        let useCase = getAllCharactersUseCase
        Task {
            let result = await useCase.execute(params: .init(forceUpdate: forceUpdate))
            switch result {
            case .success(let characters):
                self.characters = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
            case .failure:
                self.characters = []
            }
        }
    }
}
