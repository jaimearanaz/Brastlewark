import SwiftUI

public struct HomeView<ViewModel: HomeViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    private var localizables = Localizables()

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
        .onAppear {
            viewModel.didOnAppear()
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
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.didRefreshCharacters()
        }
    }

    var emptyView: some View {
        GeometryReader { geometry in
            ScrollView {
                Spacer()
                    .frame(height: geometry.size.height / 3)
                Text(localizables.empty)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshable {
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
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshable {
                viewModel.didRefreshCharacters()
            }
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
            Button(localizables.filter) {
                Task {
                    viewModel.didTapFilterButton()
                }
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
    struct Localizables {
        let title = "HOME_TITLE".localized
        let search = "HOME_SEARCH".localized
        let reset = "HOME_RESET_BUTTON".localized
        let filter = "HOME_FILTER_BUTTON".localized
        let empty = "HOME_EMPTY".localized
        let noInternet = "HOME_ERROR_NO_INTERNET".localized
        let generalError = "HOME_ERROR_GENERAL".localized
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
