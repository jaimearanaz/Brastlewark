import Testing
@testable import Domain

struct GetAllCharactersUseCaseTests {
    @Test
    static func given_repositoryReturnsCharacters_when_execute_then_returnsSuccessWithCharacters() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let expectedCharacters = [
            Character(
                id: 1,
                name: "Test1",
                thumbnail: "thumb1",
                age: 20,
                weight: 70.0,
                height: 170.0,
                hairColor: "Red",
                professions: ["Baker"],
                friends: ["Test2"]),
            Character(
                id: 2,
                name: "Test2",
                thumbnail: "thumb2",
                age: 25,
                weight: 80.0,
                height: 180.0,
                hairColor: "Blue",
                professions: ["Tinker"],
                friends: ["Test1"])
        ]
        repository.getAllCharactersResult = expectedCharacters
        repository.getAllCharactersError = nil
        let useCase = GetAllCharactersUseCase(repository: repository)
        let params = GetAllCharactersUseCaseParams(forceUpdate: false)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success(let characters):
            #expect(characters == expectedCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let useCase = GetAllCharactersUseCase(repository: repository)
        let params = GetAllCharactersUseCaseParams(forceUpdate: true)
        
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
}
