import Data
import Domain
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
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
