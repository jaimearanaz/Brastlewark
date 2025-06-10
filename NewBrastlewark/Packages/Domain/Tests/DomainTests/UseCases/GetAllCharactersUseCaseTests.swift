import Testing

@testable import Domain

struct GetAllCharactersUseCaseTests {
    @Test
    func given_repositoryReturnsCharacters_when_execute_then_returnsSuccessWithCharacters() async throws {
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
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersResult = expectedCharacters
        let useCase = GetAllCharactersUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(forceUpdate: false))

        // then
        switch result {
        case .success(let characters):
            #expect(characters == expectedCharacters)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getAllCharactersError = TestError.someError
        let useCase = GetAllCharactersUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(forceUpdate: false))

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }
}
