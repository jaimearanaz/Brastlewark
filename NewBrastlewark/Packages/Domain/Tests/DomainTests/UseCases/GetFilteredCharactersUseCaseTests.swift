import Foundation
import Testing

@testable import Domain

struct GetFilteredCharactersUseCaseTests {
    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter()
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    static func given_filterByAge_when_execute_then_returnsCharactersWithinAgeRange() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(age: 100...200)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByWeight_when_execute_then_returnsCharactersWithinWeightRange() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(weight: 39...41)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByHeight_when_execute_then_returnsCharactersWithinHeightRange() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(height: 120...130)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByHairColor_when_execute_then_returnsCharactersWithHairColor() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(hairColor: ["Red"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByMultipleHairColors_when_execute_then_returnsCharactersWithAnyOfHairColors() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(hairColor: ["Red", "Green"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByProfession_when_execute_then_returnsCharactersWithProfession() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(profession: ["Baker"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

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
    static func given_filterByMultipleProfessions_when_execute_then_returnsCharactersWithAnyOfProfessions() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(profession: ["Baker", "Tinker"])
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { $0.professions.contains(where: { ["Baker", "Tinker"].contains($0) }) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    static func given_filterByFriendsCount_when_execute_then_returnsCharactersWithinFriendsRange() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(friends: 2...4)
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (2...4).contains($0.friends.count) })
        default:
            #expect(Bool(false))
        }
    }

    @Test
    static func given_filterByAllFields_when_execute_then_returnsCharactersMatchingAllCriteria() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetFilteredCharactersUseCase(repository: repository)
        let filter = Filter(
            age: 100...300,
            weight: 38...45,
            height: 98...130,
            hairColor: ["Green", "Red"],
            profession: ["Tinker", "Baker"],
            friends: 1...4
        )
        let params = GetFilteredCharactersUseCaseParams(filter: filter)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let filtered):
            #expect(!filtered.isEmpty)
            #expect(filtered.allSatisfy { (100...300).contains($0.age) })
            #expect(filtered.allSatisfy { (38.0...45.0).contains($0.weight) })
            #expect(filtered.allSatisfy { (98.0...130.0).contains($0.height) })
            #expect(filtered.allSatisfy { ["Green", "Red"].contains($0.hairColor) })
            #expect(filtered.allSatisfy { $0.professions.contains(where: { ["Tinker", "Baker"].contains($0) }) })
            #expect(filtered.allSatisfy { (1...4).contains($0.friends.count) })
        default:
            #expect(Bool(false))
        }
    }
}

private extension GetFilteredCharactersUseCaseTests {
    static func loadCharactersFromJSON() throws -> [Character] {
        let url = Bundle.module.url(forResource: "characters", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Character].self, from: data)
    }
}
