import Foundation
import Domain

extension HomeViewModelProtocol {
    static var preview: HomeViewModelMock {
        var characters: [Character] = []
        do {
            characters = try loadCharactersFromJSON()
        } catch {
            fatalError("Failed to load characters from JSON: \(error)")
        }
        let charactersUi = CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
        return HomeViewModelMock(state: .ready(charactersUi))
    }

    static var loading: HomeViewModelMock {
        return HomeViewModelMock(didViewLoadCallback: { })
    }

    static var empty: HomeViewModelMock {
        return HomeViewModelMock(state: .empty, didViewLoadCallback: { })
    }

    static var noInternet: HomeViewModelMock {
        return HomeViewModelMock(state: .error(.noInternetConnection), didViewLoadCallback: { })
    }

    static var generalError: HomeViewModelMock {
        return HomeViewModelMock(state: .error(.generalError), didViewLoadCallback: { })
    }
}
