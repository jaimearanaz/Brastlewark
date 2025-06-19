import SwiftUI
import Domain

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack(spacing: 0) {
                        searchBar
                        characterList
                    }
                    .refreshable {
                        viewModel.didRefreshCharacters()
                    }
                }
            }
            .navigationTitle("Brastlewark")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarButtons
                }
            }
            .task {
                await viewModel.didViewLoad()
            }
        }
    }

    private var searchBar: some View {
        TextField("Enter name or profession", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding()
    }

    private var characterList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.characters) { character in
                    CharacterCell(character: character)
                }
            }
            .padding()
        }
    }

    private var toolbarButtons: some View {
        HStack(spacing: 16) {
            Button("Reset") {
                Task {
                    await viewModel.didTapResetButton()
                }
            }
            NavigationLink {
                Text("Filter View") // TODO: Implement FilterView
            } label: {
                Text("Filter")
            }
        }
    }
}

#Preview {
    HomeView(viewModel: .preview)
}
