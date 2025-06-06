import Testing
@testable import Domain

struct GetAvailableFilterUseCaseTests {
    @Test
    func given_repositories_return_characters_and_filter_when_execute_then_returns_success_with_filter() async throws {
        // given
        let expectedCharacters = [Character(
            id: 1,
            name: "Test",
            thumbnail: "",
            age: 1,
            weight: 2,
            height: 3,
            hairColor: "red",
            professions: [],
            friends: [])]
        let expectedFilter = Filter(age: 1...2, weight: 3...4, height: 5...6, friends: 7...8)
        let charactersRepositoryMock = CharactersRepositoryMock()
        charactersRepositoryMock.getAllCharactersResult = expectedCharacters
        let filterRepositoryMock = FilterRepositoryMock()
        filterRepositoryMock.getAvailableFilterResult = expectedFilter
        let useCase = GetAvailableFilterUseCase(
            charactersRepository: charactersRepositoryMock,
            filterRepository: filterRepositoryMock
        )

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_characters_repository_throws_error_when_execute_then_returns_failure() async throws {
        // given
        enum TestError: Error { case someError }
        let charactersRepositoryMock = CharactersRepositoryMock()
        charactersRepositoryMock.getAllCharactersError = TestError.someError
        let filterRepositoryMock = FilterRepositoryMock()
        let useCase = GetAvailableFilterUseCase(
            charactersRepository: charactersRepositoryMock,
            filterRepository: filterRepositoryMock
        )

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }

    @Test
    func given_filter_repository_throws_error_when_execute_then_returns_failure() async throws {
        // given
        enum TestError: Error { case someError }
        let charactersRepositoryMock = CharactersRepositoryMock()
        let filterRepositoryMock = FilterRepositoryMock()
        filterRepositoryMock.getAvailableFilterError = TestError.someError
        let useCase = GetAvailableFilterUseCase(
            charactersRepository: charactersRepositoryMock,
            filterRepository: filterRepositoryMock
        )

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }
}
