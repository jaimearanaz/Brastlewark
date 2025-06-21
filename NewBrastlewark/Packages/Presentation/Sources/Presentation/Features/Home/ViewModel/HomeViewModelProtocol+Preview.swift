import Foundation
import Domain

extension HomeViewModelProtocol {
    static var full: HomeViewModelMock {
        HomeViewModelMock(state: .ready(getCharacters()))
    }

    static var partial: HomeViewModelMock {
        let characters = getCharacters()
        let halfCharacters = Array(characters.prefix(characters.count / 2))
        return HomeViewModelMock(state: .ready(halfCharacters))
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

    private static func getCharacters() -> [CharacterUIModel] {
        var characters: [Character] = []
        do {
            characters = try loadCharactersFromJSON()
        } catch {
            fatalError("Failed to load characters from JSON: \(error)")
        }
        return CharacterMapper.map(models: characters).sorted { $0.id < $1.id }
    }
}
