import Domain
import SwiftUICore
import Swinject

@MainActor
public struct PresentationModule {
    public static func registerDependencies(inContainer container: Container) {
        registerViewModels(inContainer: container)
        registerViews(inContainer: container)
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
    }

    private static func registerViewModels(inContainer container: Container) {
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                getAllCharactersUseCase: resolveOrFail(r, GetAllCharactersUseCaseProtocol.self),
                saveSelectedCharacterUseCase: resolveOrFail(r, SaveSelectedCharacterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                getFilteredCharactersUseCase: resolveOrFail(r, GetFilteredCharactersUseCaseProtocol.self),
                deleteActiveFilterUseCase: resolveOrFail(r, DeleteActiveFilterUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(r, GetSearchedCharacterUseCaseProtocol.self),
            filterView: {
                let filterVM = resolveOrFail(r, FilterViewModel.self)
                return AnyView(FilterView(viewModel: filterVM))
            })
        }
        container.register(FilterViewModel.self) { r in
            FilterViewModel(
                getAvailableFilterUseCase: resolveOrFail(r, GetAvailableFilterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                saveActiveFilterUseCase: resolveOrFail(r, SaveActiveFilterUseCaseProtocol.self))
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
