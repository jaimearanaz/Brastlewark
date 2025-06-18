import Foundation
import Domain

public final class GetSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseProtocol {
    public init() {}
    
    public func execute(params: GetSearchedCharacterUseCaseParams) async -> Result<[Character], CharactersRepositoryError> {
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