import Testing
@testable import Domain

struct GetAvailableFilterUseCaseTests {
    @Test
    func given_repositoriesReturnCharactersAndFilter_when_execute_then_returnsSuccessWithFilter() async throws {
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
    func given_charactersRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
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
    func given_filterRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
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
