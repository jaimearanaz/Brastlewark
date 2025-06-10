import Testing

@testable import Domain

struct SaveSelectedCharacterUseCaseTests {
    @Test
    func given_repositorySucceeds_when_execute_then_returnsSuccess() async throws {
        // given
        let repositoryMock = CharactersRepositoryMock()
        let character = Character(
            id: 1,
            name: "Test",
            thumbnail: "",
            age: 1,
            weight: 2,
            height: 3,
            hairColor: "red",
            professions: [],
            friends: [])
        let useCase = SaveSelectedCharacterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(character: character))

        // then
        switch result {
        case .success:
            #expect(Bool(true))
        case .failure:
            #expect(Bool(false))
        }
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        enum TestError: Error { case someError }
        let repositoryMock = CharactersRepositoryMock()
        repositoryMock.saveSelectedCharacterError = TestError.someError
        let character = Character(
            id: 1,
            name: "Test",
            thumbnail: "",
            age: 1,
            weight: 2,
            height: 3,
            hairColor: "red",
            professions: [],
            friends: [])
        let useCase = SaveSelectedCharacterUseCase(repository: repositoryMock)

        // when
        let result = await useCase.execute(params: .init(character: character))

        // then
        switch result {
        case .success:
            #expect(Bool(false))
        case .failure(let error):
            #expect(error is TestError)
        }
    }
}
