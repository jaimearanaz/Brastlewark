import Testing
import Foundation

@testable import Domain

struct GetFilteredCharactersUseCaseTests {
    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersError = TestError.someError
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(age: 1...2, weight: 3...4, height: 5...6, friends: 7...8)

        // when
        let result = await useCase.execute(params: .init(filter: filter))

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }

    @Test
    func given_filterByAge_when_execute_then_returnsCharactersWithinAgeRange() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(age: 20...50)
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { (20...50).contains($0.age) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByWeight_when_execute_then_returnsCharactersWithinWeightRange() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let  repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(weight: 36...40)
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { (36...40).contains(Int($0.weight)) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByHeight_when_execute_then_returnsCharactersWithinHeightRange() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(height: 122...130)
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { (122...130).contains(Int($0.height)) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByHairColor_when_execute_then_returnsCharactersWithHairColor() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(hairColor: ["Red"])
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { $0.hairColor == "Red" })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByMultipleHairColors_when_execute_then_returnsCharactersWithAnyOfHairColors() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(hairColor: ["Red", "Green"])
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { ["Red", "Green"].contains($0.hairColor) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByProfession_when_execute_then_returnsCharactersWithProfession() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(profession: ["Baker"])
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { $0.professions.contains("Baker") })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByMultipleProfessions_when_execute_then_returnsCharactersWithAnyOfProfessions() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(profession: ["Baker", "Tinker"])
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { $0.professions.contains(where: { ["Baker", "Tinker"].contains($0) }) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByFriendsCount_when_execute_then_returnsCharactersWithinFriendsRange() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(friends: 3...4)
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { (3...4).contains($0.friends.count) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_filterByAllFields_when_execute_then_returnsCharactersMatchingAllCriteria() async throws {
        // given
        let allCharacters = try loadCharactersFromJSON()
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = allCharacters
        let useCase = GetFilteredCharactersUseCase(repository: repositoryMock)
        let filter = Filter(
            age: 20...50,
            weight: 36...42,
            height: 90...115,
            hairColor: ["Red", "Green"],
            profession: ["Tinker", "Baker"],
            friends: 2...3
        )
        // when
        let result = await useCase.execute(params: .init(filter: filter))
        // then
        switch result {
        case .success(let characters):
            #expect(characters.allSatisfy { (20...50).contains($0.age) })
            #expect(characters.allSatisfy { (36...42).contains(Int($0.weight)) })
            #expect(characters.allSatisfy { (90...115).contains(Int($0.height)) })
            #expect(characters.allSatisfy { ["Red", "Green"].contains($0.hairColor) })
            #expect(characters.allSatisfy { $0.professions.contains(where: { ["Tinker", "Baker"].contains($0) }) })
            #expect(characters.allSatisfy { (2...3).contains($0.friends.count) })
            #expect(!characters.isEmpty)
        case .failure:
            #expect(Bool(false))
        }
    }
}

private extension GetFilteredCharactersUseCaseTests {
    func loadCharactersFromJSON() throws -> [Character] {
        let url = Bundle.module.url(forResource: "filter_characters", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Character].self, from: data)
    }
}
