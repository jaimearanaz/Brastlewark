import Domain
import Foundation
import Observation

public enum HomeError: Sendable {
    case noInternetConnection
    case generalError
}

public enum HomeState: Sendable {
    case loading
    case ready(characters: [CharacterUIModel], reset: Bool = false)
    case empty
    case error(HomeError)
}

@MainActor
public protocol HomeViewModelProtocol: AnyObject, Observable {
    // Outputs
    var state: HomeState { get }
    var searchText: String { get set }

    // Inputs
    func viewIsReady()
    func didSelectCharacter(_ character: CharacterUIModel)
    func didTapFilterButton()
    func didTapResetButton()
    func didSearchTextChanged()
    func didRefreshCharacters()
}

@MainActor
@Observable
public final class HomeViewModel: HomeViewModelProtocol {
    public var state: HomeState = .loading
    public var searchText = "" {
        didSet {
            scheduleSearch(for: searchText)
        }
    }

    private let minSearchChars = 3
    @ObservationIgnored private(set) var needsReload = true
    @ObservationIgnored private var searchTask: Task<Void, Never>?
    @ObservationIgnored private var loadTask: Task<Void, Never>?
    private let router: any RouterProtocol
    private let tracker: HomeTrackerProtocol
    private let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol
    private let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol
    private let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol
    private let deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol
    private let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol

    // MARK: - Public methods

    public init(
        router: any RouterProtocol,
        tracker: HomeTrackerProtocol,
        getAllCharactersUseCase: GetAllCharactersUseCaseProtocol,
        getActiveFilterUseCase: GetActiveFilterUseCaseProtocol,
        getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol,
        deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol,
        getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol) {
            self.router = router
            self.tracker = tracker
            self.getAllCharactersUseCase = getAllCharactersUseCase
            self.getActiveFilterUseCase = getActiveFilterUseCase
            self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
            self.deleteActiveFilterUseCase = deleteActiveFilterUseCase
            self.getSearchedCharacterUseCase = getSearchedCharacterUseCase
    }

    deinit {
        searchTask?.cancel()
        loadTask?.cancel()
    }

    public func viewIsReady() {
        guard needsReload else {
            return
        }

        needsReload = false
        tracker.track(event: .screenViewed)
        loadCharacters()
    }

    public func didSelectCharacter(_ character: CharacterUIModel) {
        tracker.track(event: .characterSelected(characterId: character.id))
        router.navigate(to: .details(characterId: character.id, showHome: false))
    }

    public func didTapFilterButton() {
        tracker.track(event: .filterTapped)
        router.navigate(to: .filter)
    }

    public func didTapResetButton() {
        tracker.track(event: .resetTapped)
        searchText = ""
        searchTask?.cancel()
        loadAllCharacters()
    }

    public func didSearchTextChanged() {
        scheduleSearch(for: searchText, debounce: false)
    }

    public func didRefreshCharacters() {
        searchText = ""
        searchTask?.cancel()
        tracker.track(event: .refreshed)
        loadAllCharacters(forceUpdate: true)
    }
}

// MARK: - Private methods

private extension HomeViewModel {
    func scheduleSearch(for text: String, debounce: Bool = true) {
        searchTask?.cancel()

        searchTask = Task { [weak self] in
            guard let self else {
                return
            }

            if debounce {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                } catch {
                    return
                }
            }

            guard !Task.isCancelled else {
                return
            }

            if text.count < minSearchChars {
                loadAllCharacters()
            } else {
                await searchCharacters(matching: text)
            }
        }
    }

    func searchCharacters(matching text: String) async {
        guard !Task.isCancelled else {
            return
        }

        loadTask?.cancel()
        tracker.track(event: .searchChanged(text: text))
        let result = await getSearchedCharacterUseCase.execute(params: .init(searchText: text))

        guard !Task.isCancelled, text == searchText else {
            return
        }

        switch result {
        case .success(let characters):
            let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
            state = .ready(characters: charactersUi)
        case .failure(let error):
            handleResultError(error)
        }
    }

    func loadCharacters() {
        loadTask?.cancel()
        state = .loading
        let getActiveFilterUseCase = getActiveFilterUseCase
        let task = Task {
            let result = await getActiveFilterUseCase.execute()
            guard !Task.isCancelled else {
                return
            }

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
        loadTask = task
    }

    func loadAllCharacters(forceUpdate: Bool = false) {
        loadTask?.cancel()
        state = .loading
        let useCase = getAllCharactersUseCase
        let task = Task {
            let result = await useCase.execute(params: .init(forceUpdate: forceUpdate))
            guard !Task.isCancelled else {
                return
            }

            switch result {
            case .success(let characters):
                let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
                if charactersUi.isEmpty {
                    self.state = .empty
                    tracker.track(event: .emptyScreenViewed)
                } else {
                    self.state = .ready(characters: charactersUi)
                }
            case .failure(let error):
                handleResultError(error)
            }
        }
        loadTask = task
    }

    func loadFilteredCharacters(filter: Filter) {
        loadTask?.cancel()
        state = .loading
        let getFilteredCharactersUseCase = getFilteredCharactersUseCase
        let task = Task {
            let result = await getFilteredCharactersUseCase.execute(params: .init(filter: filter))
            guard !Task.isCancelled else {
                return
            }

            switch result {
            case .success(let characters):
                let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
                if charactersUi.isEmpty {
                    self.state = .empty
                    tracker.track(event: .emptyScreenViewed)
                } else {
                    self.state = .ready(characters: charactersUi, reset: true)
                }
            case .failure(let error):
                handleResultError(error)
            }
        }
        loadTask = task
    }

    func handleResultError(_ error: Error) {
        switch error {
        case CharactersRepositoryError.noInternetConnection, FilterRepositoryError.noInternetConnection:
            state = .error(.noInternetConnection)
            tracker.track(event: .errorScreenViewed)
        default:
            state = .error(.generalError)
            tracker.track(event: .errorScreenViewed)
        }
    }
}

// MARK: - FilterDelegate

extension HomeViewModel: FilterDelegate {
    public func filterDidChangeAndApply() {
        searchTask?.cancel()
        loadTask?.cancel()
        needsReload = true
        state = .loading
    }
}
