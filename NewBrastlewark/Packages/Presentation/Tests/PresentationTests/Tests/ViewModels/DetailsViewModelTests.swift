import Testing
import Combine
import Domain

@testable import Presentation

struct DetailsViewModelTests {
    @Test
    func givenCharacterId_whenDidViewLoad_thenLoadsCharacterDetailsAndFriends() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let character = Character.mock(
            id: 42,
            name: "Test Character",
            friends: ["Friend One"]
        )
        getCharacterByIdUseCase.executeResult = .success(character)

        let friend = Character.mock(id: 101, name: "Friend One")
        getSearchedCharacterUseCase.executeResult = .success([friend])

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didViewLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(details) = state {
            #expect(details.name == "Test Character")
            #expect(details.friends.count == 1)
            #expect(details.friends.first?.id == 101)
            #expect(details.friends.first?.name == "Friend One")
            #expect(getCharacterByIdUseCase.capturedId == 42)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenNoCharacterFound_whenDidViewLoad_thenShowsError() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getCharacterByIdUseCase.executeResult = .success(nil)

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didViewLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case .error = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .error state but got \(state)")
        }
    }

    @Test
    func givenRepositoryError_whenDidViewLoad_thenShowsError() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getCharacterByIdUseCase.executeResult = .failure(.unableToFetchCharacters)

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didViewLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case .error = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .error state but got \(state)")
        }
    }

    @Test
    func givenCharacterWithNoFriends_whenDidViewLoad_thenShowsDetailsWithEmptyFriendsList() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let character = Character.mock(id: 42, name: "Lonely Character", friends: [])
        getCharacterByIdUseCase.executeResult = .success(character)

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didViewLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(details) = state {
            #expect(details.name == "Lonely Character")
            #expect(details.friends.isEmpty)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenCharacterId_whenDidSelectCharacter_thenNavigatesToDetailsWithCorrectId() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didSelectCharacter(99)

        // then
        #expect(router.didNavigateToRoute.called)
        if case .details(let characterId, let showHome)? = router.didNavigateToRoute.route {
            #expect(characterId == 99)
            #expect(showHome)
        } else {
            #expect(Bool(false), "Expected .details route but got \(String(describing: router.didNavigateToRoute.route))")
        }
    }

    @Test
    func givenCharacterId_whenDidTapHomeButton_thenNavigatesToRoot() async {
        // given
        let router = RouterMock()
        let getCharacterByIdUseCase = GetCharacterByIdUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let sut = await DetailsViewModel(
            characterId: 42,
            router: router,
            getCharacterByIdUseCase: getCharacterByIdUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase
        )

        // when
        await sut.didTapHomeButton()

        // then
        #expect(router.didNavigateToRoot)
    }
}
