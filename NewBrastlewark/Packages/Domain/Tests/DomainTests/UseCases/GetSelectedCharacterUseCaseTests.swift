import Testing

@testable import Domain

struct GetSelectedCharacterUseCaseTests {
    @Test
    func given_repository_returns_character_when_execute_then_returns_success_with_character() async throws {
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
    func given_repository_throws_error_when_execute_then_returns_failure() async throws {
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
