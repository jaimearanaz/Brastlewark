import Foundation
import Domain

extension HomeViewModelProtocol {
    static var full: HomeViewModelMock {
        HomeViewModelMock(state: .ready(characters: getCharacters()))
    }

    static var notFull: HomeViewModelMock {
        let characters = getCharacters()
        let halfCharacters = Array(characters.prefix(characters.count / 2))
        return HomeViewModelMock(state: .ready(characters: halfCharacters))
    }

    static var filtered: HomeViewModelMock {
        HomeViewModelMock(state: .ready(characters: getCharacters(), reset: true))
    }

    static var loading: HomeViewModelMock {
        return HomeViewModelMock(didOnAppearCallback: { })
    }

    static var empty: HomeViewModelMock {
        return HomeViewModelMock(state: .empty, didOnAppearCallback: { })
    }

    static var noInternet: HomeViewModelMock {
        return HomeViewModelMock(state: .error(.noInternetConnection), didOnAppearCallback: { })
    }

    static var generalError: HomeViewModelMock {
        return HomeViewModelMock(state: .error(.generalError), didOnAppearCallback: { })
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
