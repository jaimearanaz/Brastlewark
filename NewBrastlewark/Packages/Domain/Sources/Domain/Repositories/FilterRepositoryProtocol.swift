public enum FilterRepositoryError: Error {
    case noInternetConnection
    case unableToSaveFilter
    case unableToFetchFilter
    case unableToDeleteFilter
}

public protocol FilterRepositoryProtocol {
    func getAvailableFilter(fromCharacters: [Character]) async throws -> Filter
    func saveActiveFilter(_ filter: Filter) async throws
    func getActiveFilter() async throws -> Filter?
    func deleteActiveFilter() async throws
}
