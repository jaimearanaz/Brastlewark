import Domain
import SwiftUICore
import Swinject

@MainActor
public struct PresentationModule {
    public static func registerDependencies(inContainer container: Container) {
        registerRouter(inContainer: container)
        registerViewModels(inContainer: container)
        registerViews(inContainer: container)
    }

    private static func registerRouter(inContainer container: Container) {
        container.register(Router.self) { r in
            Router()
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

    private static func registerViewModels(inContainer container: Container) {
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                router: resolveOrFail(r, Router.self),
                getAllCharactersUseCase: resolveOrFail(r, GetAllCharactersUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                getFilteredCharactersUseCase: resolveOrFail(r, GetFilteredCharactersUseCaseProtocol.self),
                deleteActiveFilterUseCase: resolveOrFail(r, DeleteActiveFilterUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(r, GetSearchedCharacterUseCaseProtocol.self))
        }
        container.register(FilterViewModel.self) { r in
            FilterViewModel(
                getAvailableFilterUseCase: resolveOrFail(r, GetAvailableFilterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                saveActiveFilterUseCase: resolveOrFail(r, SaveActiveFilterUseCaseProtocol.self))
        }
        container.register(DetailsViewModel.self) { r in
            DetailsViewModel(
                router: resolveOrFail(r, Router.self),
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
