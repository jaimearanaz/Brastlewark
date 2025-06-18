import SwiftUI
import SwiftData
import Domain
import Data
import Presentation

@main
struct NewBrastlewarkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if let homeViewModel = DIContainer.shared.resolve(HomeViewModel.self) {
                HomeView(viewModel: homeViewModel)
            } else {
                Text("Error initializing dependencies")
                    .foregroundColor(.red)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
