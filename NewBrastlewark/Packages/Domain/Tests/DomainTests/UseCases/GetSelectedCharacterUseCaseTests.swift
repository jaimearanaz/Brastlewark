import Testing

@testable import Domain

struct GetSelectedCharacterUseCaseTests {
    @Test
    func given_repositoryReturnsCharacter_when_execute_then_returnsSuccessWithCharacter() async throws {
        // given
        let expectedCharacter = Character(
            id: 1,
            name: "Test",
            thumbnail: "",
            age: 1,
            weight: 2,
            height: 3,
            hairColor: "red",
            professions: [],
            friends: [])
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getSelectedCharacterResult = expectedCharacter
        let useCase = GetSelectedCharacterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute()

        // then
        switch result {
        case .success(let character):
            #expect(character == expectedCharacter)
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.getSelectedCharacterError = TestError.someError
        let useCase = GetSelectedCharacterUseCase(repository: repositoryMock)

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
