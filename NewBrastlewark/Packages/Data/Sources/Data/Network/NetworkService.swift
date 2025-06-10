import Foundation
import Combine

protocol NetworkServiceProtocol {
    func getCharacters() async throws -> [CharacterEntity]
}

class NetworkService: NetworkServiceProtocol {
    var url: String
    var retries: Int
    var networkStatus: NetworkStatusProtocol
    var urlSession: URLSession
    var cancellable: AnyCancellable?

    init(baseUrl: String,
         retries: Int = 3,
         networkStatus: NetworkStatusProtocol,
         urlSession: URLSession = .shared) {
        self.url = baseUrl
        self.retries = retries
        self.networkStatus = networkStatus
        self.urlSession = urlSession
    }

    func getCharacters() async throws -> [CharacterEntity] {
        try await withCheckedThrowingContinuation { continuation in
            guard networkStatus.isInternetAvailable() else {
                continuation.resume(throwing: NetworkErrors.noNetwork)
                return
            }
            guard url.isValidNetworkURL, let url = URL(string: url) else {
                continuation.resume(throwing: NetworkErrors.wrongUrl)
                return
            }
            cancellable = urlSession.dataTaskPublisher(for: url)
                .mapError { error -> NetworkErrors in
                    if error.errorCode == -1001 {
                        return .timeout
                    } else {
                        return .general
                    }
                }
                .retry(retries)
                .tryMap { (data, response) -> CityEntity in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkErrors.general
                    }
                    if response.statusCode == 200 {
                        let decoder = JSONDecoder()
                        if let city = try? decoder.decode(CityEntity.self, from: data) {
                            return city
                        } else {
                            throw NetworkErrors.wrongJson
                        }
                    } else {
                        throw NetworkErrors.statusError(response.statusCode)
                    }
                }
                .map { $0.brastlewark }
                .sink(receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        if let networkError = error as? NetworkErrors {
                            continuation.resume(throwing: networkError)
                        } else if let urlError = error as? URLError, urlError.code == .timedOut {
                            continuation.resume(throwing: NetworkErrors.timeout)
                        } else {
                            continuation.resume(throwing: NetworkErrors.general)
                        }
                    }
                    self?.cancellable = nil
                }, receiveValue: { [weak self] characters in
                    continuation.resume(returning: characters)
                    self?.cancellable = nil
                })
        }
    }
}
