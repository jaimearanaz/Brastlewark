import Testing
@testable import Domain

struct GetSelectedCharacterUseCaseTests {
    @Test
    static func given_repositoryReturnsCharacter_when_execute_then_returnsSuccessWithCharacter() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let expectedCharacter = Character(id: 1, name: "Test1", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Test2"])
        repository.getSelectedCharacterResult = expectedCharacter
        repository.getSelectedCharacterError = nil
        let useCase = GetSelectedCharacterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success(let character):
            #expect(character == expectedCharacter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getSelectedCharacterCalled))
    }

    @Test
    static func given_repositoryReturnsNil_when_execute_then_returnsSuccessWithNil() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getSelectedCharacterResult = nil
        repository.getSelectedCharacterError = nil
        let useCase = GetSelectedCharacterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success(let character):
            #expect(character == nil)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getSelectedCharacterCalled))
    }

    @Test
    static func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getSelectedCharacterError = CharactersRepositoryError.unableToGetSelectedCharacter
        let useCase = GetSelectedCharacterUseCase(repository: repository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToGetSelectedCharacter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getSelectedCharacterCalled))
    }
}
