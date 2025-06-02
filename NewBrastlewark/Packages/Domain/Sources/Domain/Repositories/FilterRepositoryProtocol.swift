import Foundation

public protocol FilterRepositoryProtocol {
    func getAvailableFilter(fromCharacters: [Character]) async throws -> Filter
}
