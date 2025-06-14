import Foundation
import Domain

@MainActor
enum PreviewUseCaseMocks {
    static let getAllCharactersUseCase: GetAllCharactersUseCaseProtocol = GetAllCharactersUseCaseMock()
    static let saveSelectedCharacterUseCase: SaveSelectedCharacterUseCaseProtocol = SaveSelectedCharacterUseCaseMock()
    static let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol = GetActiveFilterUseCaseMock()
    static let getFilteredCharactersUseCase: GetFilteredCharactersUseCaseProtocol = GetFilteredCharactersUseCaseMock()
    static let deleteActiveFilterUseCase: DeleteActiveFilterUseCaseProtocol = DeleteActiveFilterUseCaseMock()
    static let getSearchedCharacterUseCase: GetSearchedCharacterUseCaseProtocol = GetSearchedCharacterUseCaseMock()
}

// MARK: - Mock Implementations
private final class GetAllCharactersUseCaseMock: GetAllCharactersUseCaseProtocol {
    func execute(params: GetAllCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        .success([
            .init(id: 1,
                  name: "Mock Gnome 1",
                  thumbnail: "https://example.com/1.jpg",
                  age: 25,
                  weight: 65.5,
                  height: 120.0,
                  hairColor: "Red",
                  professions: ["Baker"],
                  friends: ["Friend 1", "Friend 2"]),
            .init(id: 2,
                  name: "Mock Gnome 2",
                  thumbnail: "https://example.com/2.jpg",
                  age: 35,
                  weight: 70.2,
                  height: 115.0,
                  hairColor: "Green",
                  professions: ["Miner"],
                  friends: ["Friend 3"])])
    }
}

private final class SaveSelectedCharacterUseCaseMock: SaveSelectedCharacterUseCaseProtocol {
    func execute(params: SaveSelectedCharacterUseCaseParams) async -> Result<Void, CharactersRepositoryError> {
        .success(())
    }
}

private final class GetActiveFilterUseCaseMock: GetActiveFilterUseCaseProtocol {
    func execute() async -> Result<Filter?, FilterRepositoryError> {
        .success(
            .init(
                age: 0...100,
                weight: 0...200,
                height: 0...300,
                friends: 0...10))
    }
}

private final class GetFilteredCharactersUseCaseMock: GetFilteredCharactersUseCaseProtocol {
    func execute(params: GetFilteredCharactersUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        .success([
            .init(id: 2,
                  name: "Mock Gnome 2",
                  thumbnail: "https://example.com/2.jpg",
                  age: 35,
                  weight: 70.2,
                  height: 115.0,
                  hairColor: "Green",
                  professions: ["Miner"],
                  friends: ["Friend 3"])])
    }
}

private final class DeleteActiveFilterUseCaseMock: DeleteActiveFilterUseCaseProtocol {
    func execute() async -> Result<Void, FilterRepositoryError> {
        .success(())
    }
}

private final class GetSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseProtocol {
    func execute(params: GetSearchedCharacterUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
        .success([
            .init(id: 2,
                  name: "Mock Gnome 2",
                  thumbnail: "https://example.com/2.jpg",
                  age: 35,
                  weight: 70.2,
                  height: 115.0,
                  hairColor: "Green",
                  professions: ["Miner"],
                  friends: ["Friend 3"])])
    }
}
