import SwiftUI

public struct HomeView<ViewModel: HomeViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    private var localizables = Localizables()

    // MARK: - Public methods

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle(localizables.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarButtons
                }
            }
            .onAppear {
                viewModel.didOnAppear()
            }
        }
    }

}

// MARK: - Private methods

private extension HomeView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .ready(let characters, let reset):
            VStack(spacing: 0) {
                searchBar
                characterList(characters: characters)
            }
            .refreshable {
                viewModel.didRefreshCharacters()
            }
        case .empty:
            VStack {
                Text(localizables.empty)
                    .foregroundColor(.secondary)
            }
        case .error(let error):
            VStack {
                Text(errorMessage(for: error))                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }

    func characterList(characters: [CharacterUIModel]) -> some View {
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
                }
            }
            .padding()
        }
    }

    var searchBar: some View {
        TextField(localizables.search, text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding()
    }

    var toolbarButtons: some View {
        HStack(spacing: 16) {
            Button(localizables.reset) {
                Task {
                    viewModel.didTapResetButton()
                }
            }
            .disabled(isResetDisabled)
            NavigationLink {
                viewModel.filterView()
            } label: {
                Text(localizables.filter)
            }
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
        if case .ready(_, let reset) = viewModel.state {
            return !reset
        }
        return false
    }
}

// MARK: - Constants

private extension HomeView {
    struct Localizables {
        let title = "HOME_TITLE".localized
        let search = "HOME_SEARCH".localized
        let reset = "HOME_RESET_BUTTON".localized
        let filter = "HOME_FILTER_BUTTON".localized
        let empty = "HOME_EMPTY".localized
        let noInternet = "HOME_ERROR_NO_INTERNET".localized
        let generalError = "HOME_ERROR_GENERAL".localized
        let filterView = "HOME_FILTER_VIEW".localized
    }
}

// MARK: - Previews

#Preview("Ready full") {
    HomeView(viewModel: HomeViewModel.full)
}

#Preview("Ready partial") {
    HomeView(viewModel: HomeViewModel.notFull)
}

#Preview("Loading") {
    HomeView(viewModel: HomeViewModel.loading)
}

#Preview("Empty") {
    HomeView(viewModel: HomeViewModel.empty)
}

#Preview("No Internet") {
    HomeView(viewModel: HomeViewModel.noInternet)
}

#Preview("General error") {
    HomeView(viewModel: HomeViewModel.generalError)
}
