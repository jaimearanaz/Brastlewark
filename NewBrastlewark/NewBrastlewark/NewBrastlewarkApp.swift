import SwiftUI
import SwiftData
import Domain
import Data
import Presentation

@main
struct NewBrastlewarkApp: App {
    @StateObject private var router: Router

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

    init() {
        guard let resolvedRouter = DIContainer.shared.resolve(RouterProtocol.self) else {
            fatalError("Could not resolve Router from DIContainer")
        }
        _router = StateObject(wrappedValue: resolvedRouter as! Router)
    }

    var body: some Scene {
        WindowGroup {
            if let homeViewModel = DIContainer.shared.resolve(HomeViewModel.self),
               let filterViewModel = DIContainer.shared.resolve(FilterViewModel.self),
               let detailsViewModel = DIContainer.shared.resolve(DetailsViewModel.self) {
                NavigationStack(path: $router.path) {
                    HomeView(viewModel: homeViewModel)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .filter:
                                FilterView(viewModel: filterViewModel)
                            case .details(let characterId, let showHome):
                                DetailsView(
                                    characterId: characterId,
                                    showHome: showHome,
                                    viewModel: detailsViewModel)
                            }
                        }
                }
            } else {
                Text("Error initializing dependencies")
                    .foregroundColor(.red)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
