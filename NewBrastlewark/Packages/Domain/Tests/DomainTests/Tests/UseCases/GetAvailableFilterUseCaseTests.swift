import Foundation
import Testing
import Swinject

@testable import Domain

final class GetAvailableFilterUseCaseTests {
    var sut: GetAvailableFilterUseCaseProtocol!
    var charactersRepositoryMock: CharactersRepositoryMock!
    var filterRepositoryMock: FilterRepositoryMock!
    
    init() {
        let container = DependencyRegistry.createFreshContainer()
        sut = container.resolve(GetAvailableFilterUseCaseProtocol.self)!
        charactersRepositoryMock = (container.resolve(CharactersRepositoryProtocol.self) as! CharactersRepositoryMock)
        filterRepositoryMock = (container.resolve(FilterRepositoryProtocol.self) as! FilterRepositoryMock)
    }
    
    @Test
    func given_bothRepositoriesReturnSuccess_when_execute_then_returnsSuccessWithFilter() async throws {
        // given
        let expectedCharacters = try loadCharactersFromJSON()
        let expectedFilter = Filter(age: 10...30, weight: 60...90, height: 160...190, hairColor: ["Red", "Blue"], profession: ["Baker", "Tinker"], friends: 1...2)
        charactersRepositoryMock.getAllCharactersResult = expectedCharacters
        filterRepositoryMock.getAvailableFilterResult = expectedFilter
        
        // when
        let result = await sut.execute()
        
        // then
        switch result {
        case .success(let filter):
            #expect(filter == expectedFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
        #expect(Bool(filterRepositoryMock.getAvailableFilterCalled))
    }

    @Test
    func given_charactersRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersError = CharactersRepositoryError.unableToFetchCharacters
        
        // when
        let result = await sut.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToFetchCharacters)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
        #expect(Bool(!filterRepositoryMock.getAvailableFilterCalled))
    }

    @Test
    func given_filterRepositoryThrowsError_when_execute_then_returnsFailure() async throws {
        // given
        charactersRepositoryMock.getAllCharactersResult = try loadCharactersFromJSON()
        filterRepositoryMock.getAvailableFilterError = FilterRepositoryError.unableToFetchFilter
        
        // when
        let result = await sut.execute()
        
        // then
        switch result {
        case .failure(let error):
            #expect(error == .unableToGetAvailableFilter)
        default:
            #expect(Bool(false))
        }
        #expect(Bool(charactersRepositoryMock.getAllCharactersCalled))
        #expect(Bool(filterRepositoryMock.getAvailableFilterCalled))
    }
}
