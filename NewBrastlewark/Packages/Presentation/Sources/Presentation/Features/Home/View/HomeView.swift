import SwiftUI
import Utils

public struct HomeView<ViewModel: HomeViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    private var localizables = Localizables()
    private var accessibilityIds = AccessibilytIdentifiers()
    private var constants = Constants()
    @FocusState private var isTextFieldFocused: Bool

    // MARK: - Public methods

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 0) {
            searchBar
            contentView
        }
        .navigationTitle(localizables.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarButtons
            }
        }
        .task {
            viewModel.viewIsReady()
        }
    }
}

// MARK: - Private methods

private extension HomeView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .ready(let characters, _):
            readyView(characters: characters)
        case .empty:
            emptyView
        case .error(let error):
            errorView(error: error)
        }
    }

    var loadingView: some View {
        VStack(alignment: .center) {
            ProgressView()
                .scaleEffect(1.5)
                .padding(.top, 20)
                .accessibilityIdentifier(accessibilityIds.loadingView)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(localizables.loading)
        .accessibilityAddTraits(.updatesFrequently)
    }

    func readyView(characters: [CharacterUIModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(characters) { character in
                    CharacterCell(character: character)
                        .onTapGesture {
                            viewModel.didSelectCharacter(character)
                        }
                        .accessibilityElement()
                        .accessibilityIdentifier("\(accessibilityIds.characterCell).\(character.id)")
                        .accessibilityLabel("\(character.name)")
                        .accessibilityAddTraits(.isButton)
                }
            }
            .padding()
        }
        .accessibilityIdentifier(accessibilityIds.charactersScroll)
        .refreshable {
            viewModel.didRefreshCharacters()
        }
        .accessibilityAction(.magicTap) {
            viewModel.didRefreshCharacters()
        }
    }

    var emptyView: some View {
        GeometryReader { geometry in
            ScrollView {
                Spacer()
                    .frame(height: geometry.size.height / 3)
                Text(localizables.emptyView)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .accessibilityIdentifier(accessibilityIds.emptyView)
                    .accessibilityLabel(localizables.emptyView)
                    .accessibilityHint(localizables.searchHint)
                    .accessibilityAddTraits([.isStaticText])
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshable {
                viewModel.didRefreshCharacters()
            }
            .accessibilityAction(.magicTap) {
                viewModel.didRefreshCharacters()
            }
        }
    }

    func errorView(error: HomeError) -> some View {
        GeometryReader { geometry in
            ScrollView {
                Spacer()
                    .frame(height: geometry.size.height / 3)
                Text(errorMessage(for: error))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .accessibilityIdentifier(accessibilityIds.errorView)
                    .accessibilityLabel(errorMessage(for: error))
                    .accessibilityAddTraits([.isStaticText])
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshable {
                viewModel.didRefreshCharacters()
            }
            .accessibilityAction(.magicTap) {
                viewModel.didRefreshCharacters()
            }
        }
    }

    var searchBar: some View {
        HStack {
            Image(systemName: constants.magnifyigGlass)
                .foregroundColor(.gray)
                .accessibilityHidden(true)

            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty && !isTextFieldFocused {
                    Text(localizables.searchHint)
                        .foregroundColor(.gray)
                        .accessibilityHidden(true)
                }

                TextField("", text: $viewModel.searchText)
                    .focused($isTextFieldFocused)
                    .accessibilityElement()
                    .accessibilityIdentifier(accessibilityIds.searchBar)
                    .accessibilityLabel(localizables.search)
                    .accessibilityHint(localizables.searchHint)
                    .accessibilityValue(viewModel.searchText.isEmpty ? localizables.emptyField : viewModel.searchText)
                    .accessibility(addTraits: .isSearchField)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        .padding(.horizontal)
        .padding(.vertical)
    }

    var toolbarButtons: some View {
        HStack(spacing: 16) {
            Button(localizables.reset) {
                Task {
                    viewModel.didTapResetButton()
                }
            }
            .disabled(isResetDisabled)
            .accessibilityIdentifier(accessibilityIds.resetButton)
            .accessibilityLabel(localizables.reset)
            .accessibilityHint(localizables.resetHint)
            .accessibilityValue(isResetDisabled ? localizables.deactive : localizables.active)
            Button(localizables.filter) {
                Task {
                    viewModel.didTapFilterButton()
                }
            }
            .accessibilityIdentifier(accessibilityIds.filterButton)
            .accessibilityLabel(localizables.filter)
            .accessibilityHint(localizables.filterHint)
        }
    }

    func errorMessage(for error: HomeError) -> String {
        switch error {
        case .noInternetConnection:
            return localizables.noInternet
        case .generalError:
            return localizables.generalError
        }
    }

    var isResetDisabled: Bool {
        switch viewModel.state {
        case .loading, .empty, .error:
            return true
        case .ready(_, let reset):
            return !reset
        }
    }
}

// MARK: - Constants

private extension HomeView {
    struct Constants {
        let magnifyigGlass = "magnifyingglass"
    }

    struct Localizables {
        let title = "HOME_TITLE".localized
        let search = "HOME_SEARCH".localized
        let searchHint = "HOME_SEARCH_HINT".localized
        let reset = "HOME_RESET_BUTTON".localized
        let resetHint = "HOME_RESET_BUTTON_HINT".localized
        let filter = "HOME_FILTER_BUTTON".localized
        let filterHint = "HOME_FILTER_BUTTON_HINT".localized
        let emptyView = "HOME_EMPTY".localized
        let noInternet = "HOME_ERROR_NO_INTERNET".localized
        let generalError = "HOME_ERROR_GENERAL".localized
        let active = "ACTIVE".localized
        let deactive = "DEACTIVE".localized
        let emptyField = "EMPTY".localized
        let loading = "LOADING".localized
    }

    struct AccessibilytIdentifiers {
        let resetButton = "home.reset.button"
        let filterButton = "home.filter.button"
        let searchBar = "home.search.bar"
        let charactersScroll = "home.characters.scroll"
        let characterCell = "home.character.cell"
        let emptyView = "home.empty.view"
        let errorView = "home.error.view"
        let loadingView = "home.loading.view"
    }
}

// MARK: - Previews

#Preview("Ready full") {
    HomeView(viewModel: HomeViewModelPreview.full)
}

#Preview("Ready partial") {
    HomeView(viewModel: HomeViewModelPreview.notFull)
}

#Preview("Loading") {
    HomeView(viewModel: HomeViewModelPreview.loading)
}

#Preview("Empty") {
    HomeView(viewModel: HomeViewModelPreview.empty)
}

#Preview("No Internet") {
    HomeView(viewModel: HomeViewModelPreview.noInternet)
}

#Preview("General error") {
    HomeView(viewModel: HomeViewModelPreview.generalError)
}
