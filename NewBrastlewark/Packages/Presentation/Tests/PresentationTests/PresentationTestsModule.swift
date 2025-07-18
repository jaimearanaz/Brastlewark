import Domain
import SwiftUICore
import Swinject

@testable import Presentation

@MainActor
public struct PresentationTestsModule {
    public static func registerDependencies(inContainer container: Container) {
        registerAnalytics(inContainer: container)
        registerRouter(inContainer: container)
        registerTrackers(inContainer: container)
        registerUseCases(inContainer: container)
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
            RouterMock()
        }
        .inObjectScope(.container)
    }

    private static func registerTrackers(inContainer container: Container) {
        container.register(HomeTrackerProtocol.self) { _ in
            HomeTrackerMock()
        }
        .inObjectScope(.container)
        container.register(FilterTrackerProtocol.self) { _ in
            FilterTrackerMock()
        }
        .inObjectScope(.container)
        container.register(DetailsTrackerProtocol.self) { _ in
            DetailsTrackerMock()
        }
        .inObjectScope(.container)
    }

    private static func registerViews(inContainer container: Container) {
        container.register(HomeView.self) { r in
            let viewModel = resolveOrFail(r, HomeViewModel.self)
            return HomeView(viewModel: viewModel)
        }
        container.register(FilterView.self) { r in
            let viewModel = resolveOrFail(r, FilterViewModel.self)
            return FilterView(viewModel: viewModel)
        }
        container.register(DetailsView.self) { r in
            let viewModel = resolveOrFail(r, DetailsViewModel.self)
            return DetailsView(viewModel: viewModel)
        }
    }

    private static func registerUseCases(inContainer container: Container) {
        container.register(GetAllCharactersUseCaseProtocol.self) { _ in
            GetAllCharactersUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(GetCharacterByIdUseCaseProtocol.self) { _ in
            GetCharacterByIdUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(GetFilteredCharactersUseCaseProtocol.self) { _ in
            GetFilteredCharactersUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(GetSearchedCharacterUseCaseProtocol.self) { _ in
            GetSearchedCharacterUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(GetActiveFilterUseCaseProtocol.self) { _ in
            GetActiveFilterUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(GetAvailableFilterUseCaseProtocol.self) { _ in
            GetAvailableFilterUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(SaveActiveFilterUseCaseProtocol.self) { _ in
            SaveActiveFilterUseCaseMock()
        }
        .inObjectScope(.container)
        container.register(DeleteActiveFilterUseCaseProtocol.self) { _ in
            DeleteActiveFilterUseCaseMock()
        }
        .inObjectScope(.container)
    }

    private static func registerViewModels(inContainer container: Container) {
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                router: resolveOrFail(r, (any RouterProtocol).self),
                tracker: resolveOrFail(r, HomeTrackerProtocol.self),
                getAllCharactersUseCase: resolveOrFail(r, GetAllCharactersUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                getFilteredCharactersUseCase: resolveOrFail(r, GetFilteredCharactersUseCaseProtocol.self),
                deleteActiveFilterUseCase: resolveOrFail(r, DeleteActiveFilterUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(r, GetSearchedCharacterUseCaseProtocol.self))
        }
        container.register(FilterViewModel.self) { r in
            FilterViewModel(
                router: resolveOrFail(r, (any RouterProtocol).self),
                tracker: resolveOrFail(r, FilterTrackerProtocol.self),
                getAvailableFilterUseCase: resolveOrFail(r, GetAvailableFilterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                saveActiveFilterUseCase: resolveOrFail(r, SaveActiveFilterUseCaseProtocol.self))
        }
        container.register(DetailsViewModel.self) { r in
            DetailsViewModel(
                router: resolveOrFail(r, (any RouterProtocol).self),
                tracker: resolveOrFail(r, DetailsTrackerProtocol.self),
                getCharacterByIdUseCase: resolveOrFail(r, GetCharacterByIdUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(r, GetSearchedCharacterUseCaseProtocol.self))
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
