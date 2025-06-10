import Testing
@testable import Domain

struct SaveSelectedCharacterUseCaseTests {
    @Test
    static func given_repositorySavesSuccessfully_when_execute_then_returnsSuccess() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.saveSelectedCharacterError = nil
        let useCase = SaveSelectedCharacterUseCase(repository: repository)
        let character = Character(id: 1, name: "Test1", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Test2"])
        let params = SaveSelectedCharacterUseCaseParams(character: character)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveSelectedCharacterCalled))
        #expect(repository.savedCharacter == character)
    }

    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.saveSelectedCharacterError = CharactersRepositoryError.unableToSaveSelectedCharacter
        let useCase = SaveSelectedCharacterUseCase(repository: repository)
        let character = Character(id: 1, name: "Test1", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Test2"])
        let params = SaveSelectedCharacterUseCaseParams(character: character)
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToSaveSelectedCharacter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.saveSelectedCharacterCalled))
    }
}
