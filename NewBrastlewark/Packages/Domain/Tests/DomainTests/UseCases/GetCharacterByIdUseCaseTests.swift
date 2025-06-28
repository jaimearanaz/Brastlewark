import Foundation
import Testing

@testable import Domain

struct GetCharacterByIdUseCaseTests {
    @Test
    func given_repositoryReturnsCharacters_when_executeWithExistingId_then_returnsCharacter() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetCharacterByIdUseCase(repository: repository)
        let existingId = characters.first!.id
        let params = GetCharacterByIdUseCaseParams(id: existingId)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let character):
            #expect(character?.id == existingId)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    func given_repositoryReturnsCharacters_when_executeWithNonExistingId_then_returnsNil() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = try loadCharactersFromJSON()
        repository.getAllCharactersResult = characters
        let useCase = GetCharacterByIdUseCase(repository: repository)
        let nonExistingId = (characters.map { $0.id }.max() ?? 0) + 1
        let params = GetCharacterByIdUseCaseParams(id: nonExistingId)

        // when
        let result = await useCase.execute(params: params)

        // then
        switch result {
        case .success(let character):
            #expect(character == nil)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    func given_repositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let repository = CharactersRepositoryMock()
        repository.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let useCase = GetCharacterByIdUseCase(repository: repository)
        let params = GetCharacterByIdUseCaseParams(id: 1)

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
