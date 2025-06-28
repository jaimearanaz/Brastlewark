import Combine
import SwiftUICore
import Domain
import Foundation

public enum HomeError {
    case noInternetConnection
    case generalError
}

public enum HomeState {
    case loading
    case ready(characters: [CharacterUIModel], reset: Bool = false)
    case empty
    case error(HomeError)
}

@MainActor
public protocol HomeViewModelProtocol: ObservableObject {
    // Outputs
    var state: HomeState { get }
    var searchText: String { get set }

    // Inputs
    func didOnAppear()
    func didSelectCharacter(_ character: CharacterUIModel)
    func didTapFilterButton()
    func didTapResetButton()
    func didSearchTextChanged()
    func didRefreshCharacters()
}

@MainActor
public final class HomeViewModel: HomeViewModelProtocol {
    @Published public var state: HomeState = .loading
    @Published public var searchText = "" {
        didSet {
            didSearchTextChanged()
        }
    }

    private let minSearchChars = 3
    private var searchCancellable: AnyCancellable?

    private let router: Router
    private let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol
    private let saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol
    private let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol
    private let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol
    private let deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol
    private let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol

    // MARK: - Public methods

    public init(
        router: Router,
        getAllCharactersUseCase: GetAllCharactersUseCaseProtocol,
        saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol,
        getActiveFilterUseCase: GetActiveFilterUseCaseProtocol,
        getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol,
        deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol,
        getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol) {
            self.router = router
            self.getAllCharactersUseCase = getAllCharactersUseCase
            self.saveSelectedCharacterUseCase = saveSelectedCharacterUseCase
            self.getActiveFilterUseCase = getActiveFilterUseCase
            self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
            self.deleteActiveFilterUseCase = deleteActiveFilterUseCase
            self.getSearchedCharacterUseCase = getSearchedCharacterUseCase
            setupSearchSubscription()
    }

    public func didOnAppear() {
        loadCharacters()
    }

    public func didSelectCharacter(_ character: CharacterUIModel) {
        let saveSelectedCharacterUseCase = saveSelectedCharacterUseCase
        Task {
            _ = await saveSelectedCharacterUseCase.execute(params: .init(id: character.id))
            router.navigate(to: .details)
        }
    }

    public func didTapFilterButton() {
        router.navigate(to: .filter)
    }

    public func didTapResetButton() {
        searchText = ""
        loadAllCharacters()
    }

    public func didSearchTextChanged() {
        guard searchText.count >= minSearchChars else {
            loadAllCharacters()
            return
        }
        let useCase = getSearchedCharacterUseCase
        Task {
            let result = await useCase.execute(params: .init(searchText: searchText))
            switch result {
            case .success(let characters):
                let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
                self.state = .ready(characters: charactersUi)
            case .failure(let error):
                handleResultError(error)
            }
        }
    }

    public func didRefreshCharacters() {
        searchText = ""
        loadAllCharacters(forceUpdate: true)
    }
}

// MARK: - Private methods

private extension HomeViewModel {
    func setupSearchSubscription() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didSearchTextChanged()
            }
    }

    func loadCharacters() {
        state = .loading
        let getActiveFilterUseCase = getActiveFilterUseCase
        Task {
            let result = await getActiveFilterUseCase.execute()
            switch result {
            case .success(let filter):
                if let filter = filter {
                    loadFilteredCharacters(filter: filter)
                } else {
                    loadAllCharacters()
                }
            case .failure(let error):
                handleResultError(error)
            }
        }
    }

    func loadAllCharacters(forceUpdate: Bool = false) {
        state = .loading
        let useCase = getAllCharactersUseCase
        Task {
            let result = await useCase.execute(params: .init(forceUpdate: forceUpdate))
            switch result {
            case .success(let characters):
                let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
                self.state = charactersUi.isEmpty ? .empty : .ready(characters: charactersUi)
            case .failure(let error):
                handleResultError(error)
            }
        }
    }

    func loadFilteredCharacters(filter: Filter) {
        state = .loading
        let getFilteredCharactersUseCase = getFilteredCharactersUseCase
        Task {
            let result = await getFilteredCharactersUseCase.execute(params: .init(filter: filter))
            switch result {
            case .success(let characters):
                let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
                self.state = charactersUi.isEmpty ? .empty : .ready(characters: charactersUi, reset: true)
            case .failure(let error):
                handleResultError(error)
            }
        }
    }

    func handleResultError(_ error: Error) {
        switch error {
        case CharactersRepositoryError.noInternetConnection, FilterRepositoryError.noInternetConnection:
            self.state = .error(.noInternetConnection)
        default:
            self.state = .error(.generalError)
        }
    }
}
