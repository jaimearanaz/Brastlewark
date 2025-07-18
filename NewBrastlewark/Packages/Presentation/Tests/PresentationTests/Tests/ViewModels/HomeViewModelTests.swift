import Testing
import Combine
import Domain
import Swinject

@testable import Presentation

@MainActor
struct HomeViewModelTests {
    private var sut: HomeViewModel!
    private var routerMock: RouterMock!
    private var trackerMock: HomeTrackerMock!
    private var getAllCharactersUseCaseMock: GetAllCharactersUseCaseMock!
    private var getActiveFilterUseCaseMock: GetActiveFilterUseCaseMock!
    private var getFilteredCharactersUseCaseMock: GetFilteredCharactersUseCaseMock!
    private var deleteActiveFilterUseCaseMock: DeleteActiveFilterUseCaseMock!
    private var getSearchedCharacterUseCaseMock: GetSearchedCharacterUseCaseMock!

    init() {
        let container = DependencyRegistry.createFreshContainer()
        self.sut = container.resolve(HomeViewModel.self)!
        self.routerMock = (container.resolve((any RouterProtocol).self) as! RouterMock)
        self.trackerMock = (container.resolve(HomeTrackerProtocol.self) as! HomeTrackerMock)
        self.getAllCharactersUseCaseMock = (container.resolve(GetAllCharactersUseCaseProtocol.self) as! GetAllCharactersUseCaseMock)
        self.getActiveFilterUseCaseMock = (container.resolve(GetActiveFilterUseCaseProtocol.self) as! GetActiveFilterUseCaseMock)
        self.getFilteredCharactersUseCaseMock = (container.resolve(GetFilteredCharactersUseCaseProtocol.self) as! GetFilteredCharactersUseCaseMock)
        self.deleteActiveFilterUseCaseMock = (container.resolve(DeleteActiveFilterUseCaseProtocol.self) as! DeleteActiveFilterUseCaseMock)
        self.getSearchedCharacterUseCaseMock = (container.resolve(GetSearchedCharacterUseCaseProtocol.self) as! GetSearchedCharacterUseCaseMock)
    }

    @Test
    func givenNoActiveFilter_whenDidOnAppear_thenLoadsAllCharacters() async {
        // given
        getActiveFilterUseCaseMock.executeResult = .success(nil)
        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCaseMock.executeResult = .success(expectedCharacters)

        // when
        await sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 42)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.screenViewed))
    }

    @Test
    func givenCharacter_whenDidSelectCharacter_thenRouterNavigatesToDetails() async {
        // given
        let character = CharacterUIModel.mock(id: 42)

        // when
        await sut.didSelectCharacter(character)

        // then
        #expect(routerMock.didNavigateToRoute.called)
        if case .details(let characterId, let showHome)? = routerMock.didNavigateToRoute.route {
            #expect(characterId == 42)
            #expect(showHome == false)
        } else {
            #expect(Bool(false), "Expected .details route but got \(String(describing: routerMock.didNavigateToRoute.route))")
        }
    }

    @Test
    func givenCharacters_whenDidTapFilterButton_thenRouterNavigatesToFilter() async {
        // given
        // No additional setup needed

        // when
        await sut.didTapFilterButton()

        // then
        #expect(routerMock.didNavigateToRoute.called)
        #expect(routerMock.didNavigateToRoute.route == .filter)
        #expect(await trackerMock.didTrackEvent(.filterTapped))
    }

    @Test
    func givenCharacters_whenDidTapResetButton_thenSearchTextIsClearedAndAllCharactersLoaded() async {
        // given
        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCaseMock.executeResult = .success(expectedCharacters)

        await MainActor.run {
            sut.searchText = "abc"
        }

        // when
        await sut.didTapResetButton()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let searchText = await sut.searchText
        #expect(searchText == "")

        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 42)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }

        #expect(await trackerMock.didTrackEvent(.resetTapped))
    }

    @Test
    func givenShortSearchText_whenDidSearchTextChanged_thenLoadsAllCharacters() async {
        // given
        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCaseMock.executeResult = .success(expectedCharacters)

        await MainActor.run {
            sut.searchText = "ab"
        }

        // when
        await sut.didSearchTextChanged()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 42)
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenLongSearchText_whenDidSearchTextChanged_thenSearchesCharacters() async {
        // given
        let searchedCharacter = Character.mock(id: 99, name: "Searched Character", professions: ["Wizard"])
        getSearchedCharacterUseCaseMock.executeResult = .success([searchedCharacter])

        await MainActor.run {
            sut.searchText = "wiz"
        }

        // when
        await sut.didSearchTextChanged()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 99)
            #expect(characters.first?.name == "Searched Character")
            #expect(characters.first?.professions.first == "Wizard")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenCharacters_whenDidRefreshCharacters_thenSearchTextIsClearedAndAllCharactersLoadedWithForceUpdate() async {
        // given
        let refreshedCharacter = Character.mock(id: 101, name: "Refreshed Character")
        getAllCharactersUseCaseMock.executeResult = .success([refreshedCharacter])

        await MainActor.run {
            sut.searchText = "some"
        }

        // when
        await sut.didRefreshCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let searchText = await sut.searchText
        #expect(searchText == "")

        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 101)
            #expect(characters.first?.name == "Refreshed Character")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
        #expect(getAllCharactersUseCaseMock.wasForceUpdateCalled, "forceUpdate should be true")
    }

    @Test
    func givenActiveFilter_whenHomeIsLoaded_thenAppliesFilterAndReturnsFilteredCharacters() async {
        // given
        let activeFilter = Filter.mock(age: 20...30)
        getActiveFilterUseCaseMock.executeResult = .success(activeFilter)

        let filteredCharacters = [
            Character.mock(id: 201, name: "Young Character 1", age: 25),
            Character.mock(id: 202, name: "Young Character 2", age: 28)
        ]
        getFilteredCharactersUseCaseMock.executeResult = .success(filteredCharacters)

        // when
        await sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case let .ready(characters, reset) = state {
            #expect(characters.count == 2)
            #expect(characters[0].id == 201)
            #expect(characters[0].name == "Young Character 1")
            #expect(characters[0].age == 25)
            #expect(characters[1].id == 202)
            #expect(characters[1].name == "Young Character 2")
            #expect(characters[1].age == 28)
            #expect(reset == true, "reset should be true when filter is applied")
        } else {
            #expect(Bool(false), "Expected .ready state but got \(state)")
        }
    }

    @Test
    func givenEmptyCharactersList_whenHomeIsLoaded_thenStateIsEmptyAndShowsEmptyScreen() async {
        // given
        getActiveFilterUseCaseMock.executeResult = .success(nil)
        getAllCharactersUseCaseMock.executeResult = .success([])

        // when
        await sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case .empty = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .empty state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.emptyScreenViewed))
    }

    @Test
    func givenNetworkError_whenHomeIsLoaded_thenStateIsErrorAndShowsErrorScreen() async {
        // given
        getActiveFilterUseCaseMock.executeResult = .success(nil)
        getAllCharactersUseCaseMock.executeResult = .failure(CharactersRepositoryError.noInternetConnection)

        // when
        await sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case .error(let error) = state {
            #expect(error == .noInternetConnection)
        } else {
            #expect(Bool(false), "Expected .error state but got \(state)")
        }
        #expect(await trackerMock.didTrackEvent(.errorScreenViewed))
    }
}
