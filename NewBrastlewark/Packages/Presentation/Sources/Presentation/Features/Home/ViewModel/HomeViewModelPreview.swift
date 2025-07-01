import Foundation
import Domain

@MainActor
enum HomeViewModelPreview {
    static var full: some HomeViewModelProtocol & ObservableObject {
        HomeViewModelMock(state: .ready(characters: getCharacters()))
    }

    static var notFull: some HomeViewModelProtocol & ObservableObject {
        let characters = getCharacters()
        let halfCharacters = Array(characters.prefix(characters.count / 2))
        return HomeViewModelMock(state: .ready(characters: halfCharacters))
    }

    static var filtered: some HomeViewModelProtocol & ObservableObject {
        HomeViewModelMock(state: .ready(characters: getCharacters(), reset: true))
    }

    static var loading: some HomeViewModelProtocol & ObservableObject {
        return HomeViewModelMock()
    }

    static var empty: some HomeViewModelProtocol & ObservableObject {
        return HomeViewModelMock(state: .empty)
    }

    static var noInternet: some HomeViewModelProtocol & ObservableObject {
        return HomeViewModelMock(state: .error(.noInternetConnection))
    }

    static var generalError: some HomeViewModelProtocol & ObservableObject {
        return HomeViewModelMock(state: .error(.generalError))
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
