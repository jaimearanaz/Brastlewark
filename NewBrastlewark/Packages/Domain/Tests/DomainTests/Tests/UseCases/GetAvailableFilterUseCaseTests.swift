import Foundation
import Testing

@testable import Domain

struct GetAvailableFilterUseCaseTests {
    @Test
    func given_bothRepositoriesReturnSuccess_when_execute_then_returnsSuccessWithFilter() async throws {
        // given
        let charactersRepository = CharactersRepositoryMock()
        let filterRepository = FilterRepositoryMock()
        let expectedCharacters = try loadCharactersFromJSON()
        let expectedFilter = Filter(age: 10...30, weight: 60...90, height: 160...190, hairColor: ["Red", "Blue"], profession: ["Baker", "Tinker"], friends: 1...2)
        charactersRepository.getAllCharactersResult = expectedCharacters
        filterRepository.getAvailableFilterResult = expectedFilter
        let useCase = GetAvailableFilterUseCase(charactersRepository: charactersRepository, filterRepository: filterRepository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepository.getAllCharactersCalled))
        #expect(Bool(filterRepository.getAvailableFilterCalled))
    }

    @Test
    func given_charactersRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let charactersRepository = CharactersRepositoryMock()
        let filterRepository = FilterRepositoryMock()
        charactersRepository.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        let useCase = GetAvailableFilterUseCase(
            charactersRepository: charactersRepository,
            filterRepository: filterRepository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepository.getAllCharactersCalled))
        #expect(Bool(!filterRepository.getAvailableFilterCalled))
    }

    @Test
    func given_filterRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        let charactersRepository = CharactersRepositoryMock()
        let filterRepository = FilterRepositoryMock()
        charactersRepository.getAllCharactersResult = try loadCharactersFromJSON()
        filterRepository.getAvailableFilterError = FilterRepositoryError.unableToFetchFilter
        let useCase = GetAvailableFilterUseCase(
            charactersRepository: charactersRepository,
            filterRepository: filterRepository)
        
        // when
        let result = await useCase.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToGetAvailableFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepository.getAllCharactersCalled))
        #expect(Bool(filterRepository.getAvailableFilterCalled))
    }
}
