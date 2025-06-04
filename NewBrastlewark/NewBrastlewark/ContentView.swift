import Data
import Domain
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            TextField("Search characters", text: $searchText)
                .padding()
                .onChange(of: searchText, { oldValue, newValue in
                    Task {
                        await viewModel.searchCharacters(text: newValue)
                    }
                })
            Button("Refresh characters") {
                Task {
                    await viewModel.fetchCharacters(forceUpdate: true)
                }
            }
            .padding()
            Button("Get characters") {
                Task {
                    await viewModel.fetchCharacters(forceUpdate: false)
                }
            }
            .padding()
            Button("Filter characters") {
                Task {
                    await viewModel.filterCharacters()
                }
            }
            .padding()

            if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            List(viewModel.characters, id: \.id) { character in
                Text(character.name)
            }
        }
    }
}
