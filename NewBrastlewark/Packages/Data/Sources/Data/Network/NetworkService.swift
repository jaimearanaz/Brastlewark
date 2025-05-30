import Foundation
import Combine

protocol NetworkServiceProtocol {
    func getCharacters() -> AnyPublisher<[CharacterEntity], Error>
}

class NetworkService: NetworkServiceProtocol {
    var url: String
    var retries: Int
    var networkStatus: NetworkStatusProtocol

    init(baseUrl: String,
        retries: Int = 3,
        networkStatus: NetworkStatusProtocol) {
        self.url = baseUrl
        self.retries = retries
        self.networkStatus = networkStatus
    }

    func getCharacters() -> AnyPublisher<[CharacterEntity], Error> {
        guard networkStatus.isInternetAvailable() else {
            return Fail(error: NetworkErrors.noNetwork).eraseToAnyPublisher()
        }

        guard let url = URL(string: url) else {
            return Fail(error: NetworkErrors.wrongUrl).eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
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
            .eraseToAnyPublisher()
    }
}
