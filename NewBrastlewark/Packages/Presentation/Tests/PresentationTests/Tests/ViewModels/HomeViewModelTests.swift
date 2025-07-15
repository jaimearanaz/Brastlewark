import Testing
import Combine
import Domain

@testable import Presentation

struct HomeViewModelTests {
    @Test
    func givenNoActiveFilter_whenDidOnAppear_thenLoadsAllCharacters() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getActiveFilterUseCase.executeResult = .success(nil)
        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCase.executeResult = .success(expectedCharacters)

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        #expect(await tracker.didTrackEvent(.screenViewed))
    }

    @Test
    func givenCharacter_whenDidSelectCharacter_thenRouterNavigatesToDetails() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

        let character = CharacterUIModel.mock(id: 42)

        // when
        await sut.didSelectCharacter(character)

        // then
        #expect(router.didNavigateToRoute.called)
        if case .details(let characterId, let showHome)? = router.didNavigateToRoute.route {
            #expect(characterId == 42)
            #expect(showHome == false)
        } else {
            #expect(Bool(false), "Expected .details route but got \(String(describing: router.didNavigateToRoute.route))")
        }
    }

    @Test
    func givenCharacters_whenDidTapFilterButton_thenRouterNavigatesToFilter() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

        // when
        await sut.didTapFilterButton()

        // then
        #expect(router.didNavigateToRoute.called)
        #expect(router.didNavigateToRoute.route == .filter)
        #expect(await tracker.didTrackEvent(.filterTapped))
    }

    @Test
    func givenCharacters_whenDidTapResetButton_thenSearchTextIsClearedAndAllCharactersLoaded() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCase.executeResult = .success(expectedCharacters)

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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

        #expect(await tracker.didTrackEvent(.resetTapped))
    }

    @Test
    func givenShortSearchText_whenDidSearchTextChanged_thenLoadsAllCharacters() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let expectedCharacters = [Character.mock(id: 42)]
        getAllCharactersUseCase.executeResult = .success(expectedCharacters)

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let searchedCharacter = Character.mock(id: 99, name: "Searched Character", professions: ["Wizard"])
        getSearchedCharacterUseCase.executeResult = .success([searchedCharacter])

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let refreshedCharacter = Character.mock(id: 101, name: "Refreshed Character")
        getAllCharactersUseCase.executeResult = .success([refreshedCharacter])

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        #expect(getAllCharactersUseCase.wasForceUpdateCalled, "forceUpdate should be true")
    }

    @Test
    func givenActiveFilter_whenHomeIsLoaded_thenAppliesFilterAndReturnsFilteredCharacters() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        let activeFilter = Filter.mock(age: 20...30)
        getActiveFilterUseCase.executeResult = .success(activeFilter)

        let filteredCharacters = [
            Character.mock(id: 201, name: "Young Character 1", age: 25),
            Character.mock(id: 202, name: "Young Character 2", age: 28)
        ]
        getFilteredCharactersUseCase.executeResult = .success(filteredCharacters)

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getActiveFilterUseCase.executeResult = .success(nil)
        getAllCharactersUseCase.executeResult = .success([])

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

        // when
        await sut.viewIsReady()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        let state = await sut.state
        if case .empty = state {
            #expect(true)
        } else {
            #expect(Bool(false), "Expected .empry state but got \(state)")
        }
        #expect(await tracker.didTrackEvent(.emptyScreenViewed))
    }

    @Test
    func givenNetworkError_whenHomeIsLoaded_thenStateIsErrorAndShowsErrorScreen() async {
        // given
        let router = RouterMock()
        let tracker = HomeTrackerMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getActiveFilterUseCase.executeResult = .success(nil)
        getAllCharactersUseCase.executeResult = .failure(CharactersRepositoryError.noInternetConnection)

        let sut = await HomeViewModel(
            router: router,
            tracker: tracker,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

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
        #expect(await tracker.didTrackEvent(.errorScreenViewed))
    }
}
