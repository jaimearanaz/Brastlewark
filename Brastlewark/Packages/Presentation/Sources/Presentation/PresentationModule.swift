import Domain
import SwiftUI
import Swinject

@MainActor
public struct PresentationModule {
    public static func registerDependencies(inContainer container: Container) {
        registerAnalytics(inContainer: container)
        registerRouter(inContainer: container)
        registerTrackers(inContainer: container)
        registerViewModels(inContainer: container)
        registerViews(inContainer: container)
    }

    private static func registerAnalytics(inContainer container: Container) {
        container.register(AnalyticsProtocol.self) { _ in
            Analytics()
        }
        .inObjectScope(.container)
    }

    private static func registerRouter(inContainer container: Container) {
        container.register((any RouterProtocol).self) { _ in
            Router()
        }
        .inObjectScope(.container)
    }

    private static func registerViews(inContainer container: Container) {
        container.register(HomeView.self) { resolver in
            let viewModel = resolveOrFail(resolver, HomeViewModel.self)
            return HomeView(viewModel: viewModel)
        }
        container.register(FilterView.self) { resolver in
            let viewModel = resolveOrFail(resolver, FilterViewModel.self)
            return FilterView(viewModel: viewModel)
        }
        container.register(DetailsView.self) { resolver in
            let viewModel = resolveOrFail(resolver, DetailsViewModel.self)
            return DetailsView(viewModel: viewModel)
        }
    }

    private static func registerTrackers(inContainer container: Container) {
        container.register(HomeTrackerProtocol.self) { resolver in
            HomeTracker(analytics: resolveOrFail(resolver, (any AnalyticsProtocol).self))
        }
        container.register(FilterTrackerProtocol.self) { resolver in
            FilterTracker(analytics: resolveOrFail(resolver, (any AnalyticsProtocol).self))
        }
        container.register(DetailsTrackerProtocol.self) { resolver in
            DetailsTracker(analytics: resolveOrFail(resolver, (any AnalyticsProtocol).self))
        }
    }

    private static func registerViewModels(inContainer container: Container) {
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                router: resolveOrFail(resolver, (any RouterProtocol).self),
                tracker: resolveOrFail(resolver, HomeTrackerProtocol.self),
                getAllCharactersUseCase: resolveOrFail(resolver, GetAllCharactersUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(resolver, GetActiveFilterUseCaseProtocol.self),
                getFilteredCharactersUseCase: resolveOrFail(resolver, GetFilteredCharactersUseCaseProtocol.self),
                deleteActiveFilterUseCase: resolveOrFail(resolver, DeleteActiveFilterUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(resolver, GetSearchedCharacterUseCaseProtocol.self))
        }
        container.register(FilterViewModel.self) { resolver in
            FilterViewModel(
                router: resolveOrFail(resolver, (any RouterProtocol).self),
                tracker: resolveOrFail(resolver, FilterTrackerProtocol.self),
                getAvailableFilterUseCase: resolveOrFail(resolver, GetAvailableFilterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(resolver, GetActiveFilterUseCaseProtocol.self),
                saveActiveFilterUseCase: resolveOrFail(resolver, SaveActiveFilterUseCaseProtocol.self))
        }
        container.register(FilterViewModel.self) { (resolver, delegate: any FilterDelegate) in
            FilterViewModel(
                router: resolveOrFail(resolver, (any RouterProtocol).self),
                tracker: resolveOrFail(resolver, FilterTrackerProtocol.self),
                getAvailableFilterUseCase: resolveOrFail(resolver, GetAvailableFilterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(resolver, GetActiveFilterUseCaseProtocol.self),
                saveActiveFilterUseCase: resolveOrFail(resolver, SaveActiveFilterUseCaseProtocol.self),
                delegate: delegate)
        }
        container.register(DetailsViewModel.self) { resolver in
            DetailsViewModel(
                router: resolveOrFail(resolver, (any RouterProtocol).self),
                tracker: resolveOrFail(resolver, DetailsTrackerProtocol.self),
                getCharacterByIdUseCase: resolveOrFail(resolver, GetCharacterByIdUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(resolver, GetSearchedCharacterUseCaseProtocol.self))
        }
    }

    private static func resolveOrFail<Service>(
        _ resolver: Resolver,
        _ serviceType: Service.Type) -> Service {
            guard let service = resolver.resolve(serviceType) else {
                fatalError("Dependency \(serviceType) not resolved")
            }
            return service
    }
}
