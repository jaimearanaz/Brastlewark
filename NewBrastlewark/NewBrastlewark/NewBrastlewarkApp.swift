import SwiftUI
import SwiftData
import Domain
import Data
import Presentation

@main
struct NewBrastlewarkApp: App {
    @StateObject private var router: Router
    private let homeViewModel: HomeViewModel
    private let filterViewModel: FilterViewModel
    private let detailsViewModel: DetailsViewModel

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        guard let router = DIContainer.shared.resolve((any RouterProtocol).self) as? Router,
              let homeViewModel = DIContainer.shared.resolve(HomeViewModel.self),
              let filterViewModel = DIContainer.shared.resolve(
                FilterViewModel.self,
                argument: homeViewModel as any FilterDelegate),
              let detailsViewModel = DIContainer.shared.resolve(DetailsViewModel.self) else {
            fatalError("Could not resolve application dependencies")
        }

        _router = StateObject(wrappedValue: router)
        self.homeViewModel = homeViewModel
        self.filterViewModel = filterViewModel
        self.detailsViewModel = detailsViewModel
    }

    var body: some Scene {
        WindowGroup {
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
        }
        .modelContainer(sharedModelContainer)
    }
}
