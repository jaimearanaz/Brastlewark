import Foundation
import Testing
import Swinject

@testable import Domain

final class GetFilteredCharactersUseCaseTests {
    var sut: GetFilteredCharactersUseCaseProtocol!
    var charactersRepositoryMock: CharactersRepositoryMock!
    
    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetFilteredCharactersUseCaseProtocol.self)!
        charactersRepositoryMock = (container.resolve(CharactersRepositoryProtocol.self) as! CharactersRepositoryMock)
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let filter = Filter()
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
    }

    @Test
    func given_filterByAge_when_execute_then_returnsCharactersWithinAgeRange() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(age: 100...200)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (100...200).contains($0.age) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByWeight_when_execute_then_returnsCharactersWithinWeightRange() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(weight: 39...41)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (39...41).contains(Int($0.weight)) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByHeight_when_execute_then_returnsCharactersWithinHeightRange() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(height: 120...130)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (120...130).contains(Int($0.height)) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByHairColor_when_execute_then_returnsCharactersWithHairColor() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(hairColor: ["Red"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { $0.hairColor == "Red" })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByMultipleHairColors_when_execute_then_returnsCharactersWithAnyOfHairColors() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(hairColor: ["Red", "Green"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { ["Red", "Green"].contains($0.hairColor) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByProfession_when_execute_then_returnsCharactersWithProfession() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(profession: ["Baker"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { $0.professions.contains("Baker") })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByMultipleProfessions_when_execute_then_returnsCharactersWithAnyOfProfessions() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(profession: ["Baker", "Metalworker"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { 
                $0.professions.contains("Baker") || $0.professions.contains("Metalworker") 
            })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByFriends_when_execute_then_returnsCharactersWithFriendsInRange() async throws {
        // given
        let characters = try loadCharactersFromJSON()
        charactersRepositoryMock.getAllCharactersResult = characters
        let filter = Filter(friends: 3...5)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await sut.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (3...5).contains($0.friends.count) })
        default:
            #expect(Bool(false))
        }
    }
}
