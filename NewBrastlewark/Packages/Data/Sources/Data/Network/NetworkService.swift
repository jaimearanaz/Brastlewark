import Foundation

protocol NetworkServiceProtocol {
    func getCharacters() async throws -> [CharacterEntity]
}

class NetworkService: NetworkServiceProtocol {
    var url: String
    var retries: Int
    var networkStatus: NetworkStatusProtocol
    var urlSession: URLSession

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
        guard networkStatus.isInternetAvailable() else {
            throw NetworkErrors.noNetwork
        }
        guard url.isValidNetworkURL, let url = URL(string: url) else {
            throw NetworkErrors.wrongUrl
        }

        let (data, response) = try await fetchData(from: url)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkErrors.general
        }
        guard response.statusCode == 200 else {
            throw NetworkErrors.statusError(response.statusCode)
        }
        guard let city = try? JSONDecoder().decode(CityEntity.self, from: data) else {
            throw NetworkErrors.wrongJson
        }

        return city.brastlewark
    }

    private func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        let maximumRetries = max(0, retries)
        var attempt = 0

        while true {
            do {
                return try await urlSession.data(from: url)
            } catch {
                if Task.isCancelled {
                    throw CancellationError()
                }
                guard attempt < maximumRetries else {
                    throw mapTransportError(error)
                }
                attempt += 1
            }
        }
    }

    private func mapTransportError(_ error: Error) -> NetworkErrors {
        guard let urlError = error as? URLError else {
            return .general
        }
        return urlError.code == .timedOut ? .timeout : .general
    }
}
