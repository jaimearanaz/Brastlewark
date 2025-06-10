import Foundation
import Testing

@testable import Data

struct NetworkServiceTests {
    @Test
    func given_noInternet_when_getCharacters_then_returnsNoNetworkError() async {
        let networkStatus = NetworkStatusMock()
        networkStatus.isInternetAvailableReturnValue = false
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus)
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch let error as NetworkErrors {
            #expect(error == .noNetwork)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test
    func given_invalidUrl_when_getCharacters_then_returnsWrongUrlError() async {
        let sut = NetworkService(baseUrl: "invalid url", networkStatus: NetworkStatusMock())
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch let error as NetworkErrors {
            #expect(error == .wrongUrl)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test
    func test_scenarios_with_network_mocked_responses() async {
        await given_networkTimeout_when_getCharacters_then_returnsTimeoutError()
        await given_non200StatusCode_when_getCharacters_then_returnsStatusError()
        await given_invalidJson_when_getCharacters_then_returnsWrongJsonError()
        await given_validResponse_when_getCharacters_then_returnsCharacterEntities()
        await given_networkFails_then_retriesExpectedNumberOfTimes()
    }

    func given_networkTimeout_when_getCharacters_then_returnsTimeoutError() async {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        URLProtocolMock.requestHandler = { _ in
            throw URLError(.timedOut)
        }
        defer { URLProtocolMock.requestHandler = nil }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch let error as NetworkErrors {
            #expect(error == .timeout)
        } catch {
            #expect(Bool(false))
        }
    }

    func given_non200StatusCode_when_getCharacters_then_returnsStatusError() async {
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
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch let error as NetworkErrors {
            if case .statusError(let code) = error {
                #expect(code == 404)
            } else {
                #expect(Bool(false))
            }
        } catch {
            #expect(Bool(false))
        }
    }

    func given_invalidJson_when_getCharacters_then_returnsWrongJsonError() async {
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
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch let error as NetworkErrors {
            #expect(error == .wrongJson)
        } catch {
            #expect(Bool(false))
        }
    }

    func given_validResponse_when_getCharacters_then_returnsCharacterEntities() async {
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
        defer { URLProtocolMock.requestHandler = nil }
        let sut = NetworkService(baseUrl: "https://test.com", networkStatus: networkStatus, urlSession: session)
        do {
            let characters = try await sut.getCharacters()
            #expect(!characters.isEmpty)
        } catch {
            #expect(Bool(false))
        }
    }

    func given_networkFails_then_retriesExpectedNumberOfTimes() async {
        let networkStatus = NetworkStatusMock()
        let session = makeMockSession()
        class CallCounter: @unchecked Sendable {
            private var count = 0
            private let queue = DispatchQueue(label: "CallCounterQueue")
            func increment() { queue.sync { count += 1 } }
            func value() -> Int { queue.sync { count } }
        }
        let callCounter = CallCounter()
        URLProtocolMock.requestHandler = { _ in
            callCounter.increment()
            throw URLError(.timedOut)
        }
        defer { URLProtocolMock.requestHandler = nil }
        let retries = 2
        let sut = NetworkService(
            baseUrl: "https://test.com",
            retries: retries,
            networkStatus: networkStatus,
            urlSession: session)
        do {
            _ = try await sut.getCharacters()
            #expect(Bool(false))
        } catch {
            let finalCount = callCounter.value()
            #expect(finalCount == retries + 1)
        }
    }
}

private extension NetworkServiceTests {
    private func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
