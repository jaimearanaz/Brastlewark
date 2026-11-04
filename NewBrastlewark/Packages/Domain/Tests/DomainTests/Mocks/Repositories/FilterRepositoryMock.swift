@testable import Domain

actor FilterRepositoryMock: FilterRepositoryProtocol {
    private var getAvailableFilterResult = Filter(age: 0...0, weight: 0...0, height: 0...0, friends: 0...0)
    private var getAvailableFilterError: FilterRepositoryError?
    private var getAvailableFilterCalled = false

    private var saveActiveFilterCalled = false
    private var savedActiveFilter: Filter?
    private var saveActiveFilterError: FilterRepositoryError?

    private var getActiveFilterResult: Filter?
    private var getActiveFilterError: FilterRepositoryError?
    private var getActiveFilterCalled = false

    private var deleteActiveFilterCalled = false
    private var deleteActiveFilterError: FilterRepositoryError?

    func configureAvailableFilter(
        result: Filter = Filter(age: 0...0, weight: 0...0, height: 0...0, friends: 0...0),
        error: FilterRepositoryError? = nil
    ) {
        getAvailableFilterResult = result
        getAvailableFilterError = error
    }

    func configureSaveActiveFilter(error: FilterRepositoryError? = nil) {
        saveActiveFilterError = error
    }

    func configureActiveFilter(result: Filter? = nil, error: FilterRepositoryError? = nil) {
        getActiveFilterResult = result
        getActiveFilterError = error
    }

    func configureDeleteActiveFilter(error: FilterRepositoryError? = nil) {
        deleteActiveFilterError = error
    }

    func wasGetAvailableFilterCalled() -> Bool { getAvailableFilterCalled }
    func wasSaveActiveFilterCalled() -> Bool { saveActiveFilterCalled }
    func capturedActiveFilter() -> Filter? { savedActiveFilter }
    func wasGetActiveFilterCalled() -> Bool { getActiveFilterCalled }
    func wasDeleteActiveFilterCalled() -> Bool { deleteActiveFilterCalled }

    func getAvailableFilter(fromCharacters: [Character]) async throws -> Filter {
        getAvailableFilterCalled = true
        if let getAvailableFilterError {
            throw getAvailableFilterError
        }
        return getAvailableFilterResult
    }

    func saveActiveFilter(_ filter: Filter) async throws {
        saveActiveFilterCalled = true
        savedActiveFilter = filter
        if let saveActiveFilterError {
            throw saveActiveFilterError
        }
    }

    func getActiveFilter() async throws -> Filter? {
        getActiveFilterCalled = true
        if let getActiveFilterError {
            throw getActiveFilterError
        }
        return getActiveFilterResult
    }

    func deleteActiveFilter() async throws {
        deleteActiveFilterCalled = true
        if let deleteActiveFilterError {
            throw deleteActiveFilterError
        }
    }
}
