import Testing
import Foundation

@testable import Domain

struct GetFilteredCharactersUseCaseTests {
    @Test
    func given_repository_throws_error_when_execute_then_returns_failure() async throws {
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
    func given_filter_by_age_when_execute_then_returns_characters_within_age_range() async throws {
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
    func given_filter_by_weight_when_execute_then_returns_characters_within_weight_range() async throws {
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
    func given_filter_by_height_when_execute_then_returns_characters_within_height_range() async throws {
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
    func given_filter_by_hair_color_when_execute_then_returns_characters_with_hair_color() async throws {
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
    func given_filter_by_multiple_hair_colors_when_execute_then_returns_characters_with_any_of_hair_colors() async throws {
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
    func given_filter_by_profession_when_execute_then_returns_characters_with_profession() async throws {
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
    func given_filter_by_multiple_professions_when_execute_then_returns_characters_with_any_of_professions() async throws {
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
    func given_filter_by_friends_count_when_execute_then_returns_characters_within_friends_range() async throws {
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
    func given_filter_by_all_fields_when_execute_then_returns_characters_matching_all_criteria() async throws {
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
