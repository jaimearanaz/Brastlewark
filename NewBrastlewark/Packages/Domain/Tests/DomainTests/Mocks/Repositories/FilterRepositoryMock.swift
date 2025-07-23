import Foundation

@testable import Domain

final class FilterRepositoryMock: FilterRepositoryProtocol {
    var getAvailableFilterResult = Filter(age: 0...0, weight: 0...0, height: 0...0, friends: 0...0)
    var getAvailableFilterError: Error?
    var getAvailableFilterCalled = false
    func getAvailableFilter(fromCharacters: [Character]) async throws -> Filter {
        getAvailableFilterCalled = true
        if let error = getAvailableFilterError {
            throw error
        }
        return getAvailableFilterResult
    }

    var saveActiveFilterCalled = false
    var savedActiveFilter: Filter?
    var saveActiveFilterError: Error?
    func saveActiveFilter(_ filter: Filter) async throws {
        saveActiveFilterCalled = true
        savedActiveFilter = filter
        if let error = saveActiveFilterError {
            throw error
        }
    }

    var getActiveFilterResult: Filter?
    var getActiveFilterError: Error?
    var getActiveFilterCalled = false
    func getActiveFilter() async throws -> Filter? {
        getActiveFilterCalled = true
        if let error = getActiveFilterError {
            throw error
        }
        return getActiveFilterResult
    }

    var deleteActiveFilterCalled = false
    var deleteActiveFilterError: Error?
    func deleteActiveFilter() async throws {
        deleteActiveFilterCalled = true
        if let error = deleteActiveFilterError {
            throw error
        }
    }
}
