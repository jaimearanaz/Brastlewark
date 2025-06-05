import Combine
import Foundation
import Testing

@testable import Data

struct NetworkServiceTests {
    @Test
    func given_noInternet_when_getCharacters_then_returnsNoNetworkError() {
        let networkStatus = NetworkStatusMock()
        networkStatus.isInternetAvailableReturnValue = false
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus)
        let result = awaitResult(from: sut.getCharacters())
        var isFailure = false
        if case .failure(let error) = result {
            isFailure = true
            if case .noNetwork? = error as? NetworkErrors {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
        #expect(isFailure)
    }

    @Test
    func given_invalidUrl_when_getCharacters_then_returnsWrongUrlError() {
        let sut = NetworkService(baseUrl: "invalid url", networkStatus: NetworkStatus())
        let result = awaitResult(from: sut.getCharacters())
        var isFailure = false
        if case .failure(let error) = result {
            isFailure = true
            if case .wrongUrl? = error as? NetworkErrors {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
        #expect(isFailure)
    }

    @Test
    func given_networkTimeout_when_getCharacters_then_returnsTimeoutError() {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        URLProtocolMock.requestHandler = { _ in
            throw URLError(.timedOut)
        }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        let result = awaitResult(from: sut.getCharacters())
        var isFailure = false
        if case .failure(let error) = result {
            isFailure = true
            if case .timeout? = error as? NetworkErrors {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
        #expect(isFailure)
    }

    @Test
    func given_non200StatusCode_when_getCharacters_then_returnsStatusError() {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        let result = awaitResult(from: sut.getCharacters())
        var isFailure = false
        if case .failure(let error) = result {
            isFailure = true
            if case .statusError(let code) = error as? NetworkErrors {
                #expect(code == 404)
            } else {
                #expect(Bool(false))
            }
        }
        #expect(isFailure)
    }

    @Test
    func given_invalidJson_when_getCharacters_then_returnsWrongJsonError() {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let invalidJson = Data("not a json".utf8)
            return (response, invalidJson)
        }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        let result = awaitResult(from: sut.getCharacters())
        var isFailure = false
        if case .failure(let error) = result {
            isFailure = true
            if case .wrongJson? = error as? NetworkErrors {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
        #expect(isFailure)
    }

    @Test
    func given_validResponse_when_getCharacters_then_returnsCharacterEntities() {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        let validJson = """
        { "brastlewark": [
            { "id": 1, "name": "Test", "thumbnail": "url", "age": 30, "weight": 70.0, "height": 170.0, "hair_color": "Brown", "professions": ["Farmer"], "friends": ["Friend1"] }
        ] }
        """.data(using: .utf8)!
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, validJson)
        }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        let result = awaitResult(from: sut.getCharacters())
        var isSuccess = false
        if case .success(let characters) = result {
            isSuccess = true
            #expect(characters.count == 1)
            #expect(characters.first?.name == "Test")
        }
        #expect(isSuccess)
    }

    @Test
    func given_networkFails_then_retriesExpectedNumberOfTimes() {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        var callCount = 0
        URLProtocolMock.requestHandler = { _ in
            callCount += 1
            throw URLError(.timedOut)
        }
        let retries = 2
        let sut = NetworkService(baseUrl: "https://test.com", retries: retries, networkStatus: networkStatus, urlSession: session)
        _ = awaitResult(from: sut.getCharacters())
        // El número de llamadas es el inicial + número de reintentos
        #expect(callCount == retries + 1)
    }
}

private extension NetworkServiceTests {
    func awaitResult<T: Publisher>(from publisher: T) -> Result<T.Output, T.Failure>? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T.Output, T.Failure>?
        let cancellable = publisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                result = .failure(error)
            }
            semaphore.signal()
        }, receiveValue: { value in
            result = .success(value)
            semaphore.signal()
        })
        semaphore.wait()
        _ = cancellable
        return result
    }

    private func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
