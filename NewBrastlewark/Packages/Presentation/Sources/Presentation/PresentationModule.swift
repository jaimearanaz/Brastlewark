import Domain
import Swinject

public struct PresentationModule {
    public static func registerDependencies(inContainer container: Container) {
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                getAllCharactersUseCase: resolveOrFail(r, GetAllCharactersUseCaseProtocol.self),
                saveSelectedCharacterUseCase: resolveOrFail(r, SaveSelectedCharacterUseCaseProtocol.self),
                getActiveFilterUseCase: resolveOrFail(r, GetActiveFilterUseCaseProtocol.self),
                getFilteredCharactersUseCase: resolveOrFail(r, GetFilteredCharactersUseCaseProtocol.self),
                deleteActiveFilterUseCase: resolveOrFail(r, DeleteActiveFilterUseCaseProtocol.self),
                getSearchedCharacterUseCase: resolveOrFail(r, GetSearchedCharacterUseCaseProtocol.self)
            )
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