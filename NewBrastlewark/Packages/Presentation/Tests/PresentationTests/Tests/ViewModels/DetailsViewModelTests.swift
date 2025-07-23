import Testing
import Combine
import Domain
import Swinject

@testable import Presentation

// swiftlint:disable force_cast force_unwrapping
@MainActor
struct DetailsViewModelTests {
    private var sut: DetailsViewModel!
    private var routerMock: RouterMock!
    private var trackerMock: DetailsTrackerMock!
    private var getCharacterByIdUseCaseMock: GetCharacterByIdUseCaseMock!
    private var getSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        self.sut = container.resolve(DetailsViewModel.self)!
        self.routerMock = (container.resolve((any RouterProtocol).self) as! RouterMock)
        self.trackerMock = (container.resolve(DetailsTrackerProtocol.self) as! DetailsTrackerMock)
        self.getCharacterByIdUseCaseMock = (container.resolve(GetCharacterByIdUseCaseProtocol.self) as! GetCharacterByIdUseCaseMock)
        self.getSearchedCharacterUseCaseMock = (container.resolve(GetSearchedCharacterUseCaseProtocol.self) as! GetSearchedCharacterUseCaseMock)
    }

    @Test
    func givenCharacterId_whenDidViewLoad_thenLoadsCharacterDetailsAndFriends() async {
        // given
        let character = Character.mock(
            id: 42,
            name: "Test Character",
            friends: ["Friend One"]
        )
        getCharacterByIdUseCaseMock.executeResult = .success(character)
        sut.characterId = character.id

        let friend = Character.mock(id: 101, name: "Friend One")
        getSearchedCharacterUseCaseMock.executeResult = .success([friend])

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(details) = state {
            #expect(details.name == "Test Character")
            #expect(details.friends.count == 1)
            #expect(details.friends.first?.id == 101)
            #expect(details.friends.first?.name == "Friend One")
            #expect(getCharacterByIdUseCaseMock.capturedId == 42)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.screenViewed(characterId: 42)))
    }

    @Test
    func givenNoCharacterFound_whenDidViewLoad_thenShowsError() async {
        // given
        getCharacterByIdUseCaseMock.executeResult = .success(nil)
        sut.characterId = 42

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case .error = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .error state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.errorScreenViewed))
    }

    @Test
    func givenRepositoryError_whenDidViewLoad_thenShowsError() async {
        // given
        getCharacterByIdUseCaseMock.executeResult = .failure(.unableToFetchCharacters)
        sut.characterId = 42

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case .error = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .error state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.errorScreenViewed))
    }

    @Test
    func givenCharacterWithNoFriends_whenDidViewLoad_thenShowsDetailsWithEmptyFriendsList() async {
        // given
        let character = Character.mock(id: 42, name: "Lonely Character", friends: [])
        getCharacterByIdUseCaseMock.executeResult = .success(character)
        sut.characterId = 42

        // when
        sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = sut.state
        if case let .ready(details) = state {
            #expect(details.name == "Lonely Character")
            #expect(details.friends.isEmpty)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.screenViewed(characterId: 42)))
    }

    @Test
    func givenCharacterId_whenDidSelectCharacter_thenNavigatesToDetailsWithCorrectId() async {
        // given
        sut.characterId = 42

        // when
        sut.didSelectCharacter(99)

        // then
        #expect(routerMock.didNavigateToRoute.called)
        if case .details(let characterId, let showHome)? = routerMock.didNavigateToRoute.route {
            #expect(characterId == 99)
            #expect(showHome)
        } else {
            #expect(Bool(false), "Expected .details route but got \(String(describing: routerMock.didNavigateToRoute.route))")
        }
        #expect(await trackerMock.didTrackEvent(.friendSelected(characterId: 99)))
    }

    @Test
    func givenCharacterId_whenDidTapHomeButton_thenNavigatesToRoot() async {
        // given
        sut.characterId = 42

        // when
        sut.didTapHomeButton()

        // then
        #expect(await trackerMock.didTrackEvent(.homeTapped))
        #expect(routerMock.didNavigateToRoot)
    }
}
// swiftlint:enable force_cast force_unwrapping
