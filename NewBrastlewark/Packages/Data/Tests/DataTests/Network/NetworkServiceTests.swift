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
        defer { URLProtocolMock.requestHandler = nil }
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
            let response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil)!
            return (response, Data())
        }
        defer { URLProtocolMock.requestHandler = nil }
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
            let response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            let invalidJson = Data("not a json".utf8)
            return (response, invalidJson)
        }
        defer { URLProtocolMock.requestHandler = nil }
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
        let jsonURL = Bundle.module.url(forResource: "valid_characters", withExtension: "json")!
        let validJson = try! Data(contentsOf: jsonURL)
        URLProtocolMock.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
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
    func given_networkFails_then_retriesExpectedNumberOfTimes() async {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        actor CallCounter {
            private var count = 0
            func increment() { count += 1 }
            func value() -> Int { count }
        }
        let callCounter = CallCounter()
        URLProtocolMock.requestHandler = { _ in
            Task { await callCounter.increment() }
            throw URLError(.timedOut)
        }
        let retries = 2
        let sut = NetworkService(
            baseUrl: "https://test.com",
            retries: retries,
            networkStatus: networkStatus,
            urlSession: session)
        _ = awaitResult(from: sut.getCharacters())
        let finalCount = await callCounter.value()
        #expect(finalCount == retries + 1)
    }
}

private extension NetworkServiceTests {
    func awaitResult<T: Publisher>(from publisher: T) -> Result<T.Output, T.Failure>? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T.Output, T.Failure>?
        var value: T.Output?
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                result = .failure(error)
            case .finished:
                if let v = value {
                    result = .success(v)
                }
            }
            semaphore.signal()
        }, receiveValue: { v in
            value = v
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
