import Testing
@testable import Domain

struct GetSearchedCharacterUseCaseTests {
    @Test
    static func given_repositoryReturnsCharacters_when_executeWithMatchingName_then_returnsCharactersWithName() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = [
            Character(id: 1, name: "Alice", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Bob"]),
            Character(id: 2, name: "Bob", thumbnail: "thumb2", age: 25, weight: 80.0, height: 180.0, hairColor: "Blue", professions: ["Tinker"], friends: ["Alice"])
        ]
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "ali")
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success(let filtered):
            #expect(filtered == [characters[0]])
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    static func given_repositoryReturnsCharacters_when_executeWithMatchingProfession_then_returnsCharactersWithProfession() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = [
            Character(id: 1, name: "Alice", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Bob"]),
            Character(id: 2, name: "Bob", thumbnail: "thumb2", age: 25, weight: 80.0, height: 180.0, hairColor: "Blue", professions: ["Tinker"], friends: ["Alice"])
        ]
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "tink")
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success(let filtered):
            #expect(filtered == [characters[1]])
        default:
            #expect(Bool(false))
        }
        #expect(Bool(repository.getAllCharactersCalled))
    }

    @Test
    static func given_repositoryReturnsCharacters_when_executeWithEmptySearchText_then_returnsAllCharacters() async throws {
        // given
        let repository = CharactersRepositoryMock()
        let characters = [
            Character(id: 1, name: "Alice", thumbnail: "thumb1", age: 20, weight: 70.0, height: 170.0, hairColor: "Red", professions: ["Baker"], friends: ["Bob"]),
            Character(id: 2, name: "Bob", thumbnail: "thumb2", age: 25, weight: 80.0, height: 180.0, hairColor: "Blue", professions: ["Tinker"], friends: ["Alice"])
        ]
        repository.getAllCharactersResult = characters
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "")
        
        // when
        let result = await useCase.execute(params: params)
        
        // then
        switch result {
        case .success(let filtered):
            #expect(filtered == characters)
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
        let useCase = GetSearchedCharacterUseCase(repository: repository)
        let params = GetSearchedCharacterUseCaseParams(searchText: "Alice")
        
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
