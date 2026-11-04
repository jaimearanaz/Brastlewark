import Synchronization

@testable import Domain

final class CharactersRepositoryMock: CharactersRepositoryProtocol, Sendable {
    private struct State: Sendable {
        var result: [Character] = []
        var error: CharactersRepositoryError?
        var called = false
    }

    private let state = Mutex(State())

    var getAllCharactersResult: [Character] {
        get { state.withLock { $0.result } }
        set { state.withLock { $0.result = newValue } }
    }

    var getAllCharactersError: CharactersRepositoryError? {
        get { state.withLock { $0.error } }
        set { state.withLock { $0.error = newValue } }
    }

    var getAllCharactersCalled: Bool {
        state.withLock { $0.called }
    }

    func getAllCharacters(forceUpdate: Bool) async throws -> [Character] {
        try state.withLock {
            $0.called = true
            if let error = $0.error {
                throw error
            }
            return $0.result
        }
    }
}
