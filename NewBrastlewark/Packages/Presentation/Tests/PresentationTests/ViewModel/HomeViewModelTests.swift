import Testing
import Combine
@testable import Presentation
import Domain

struct HomeViewModelTests {
    @Test func givenNoActiveFilter_whenDidOnAppear_thenLoadsAllCharacters() async {
        // given
        let router = RouterMock()
        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()

        getActiveFilterUseCase.executeResult = .success(nil)
        let expectedCharacters = [Character(
            id: 1,
            name: "Test",
            thumbnail: "",
            age: 10,
            weight: 20,
            height: 30,
            hairColor: "",
            professions: [],
            friends: [])]
        getAllCharactersUseCase.executeResult = .success(expectedCharacters)

        let sut = await HomeViewModel(
            router: router,
            getAllCharactersUseCase: getAllCharactersUseCase,
            getActiveFilterUseCase: getActiveFilterUseCase,
            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
            getSearchedCharacterUseCase: getSearchedCharacterUseCase)

        // when
        await sut.didOnAppear()

        // Espera un poco para asegurar que las operaciones asíncronas se completen
        try? await Task.sleep(nanoseconds: 100_000_000)  // 100ms

        // then
        let state = await sut.state
        if case let .ready(characters, _) = state {
            #expect(characters.count == 1)
            #expect(characters.first?.id == 1)
        } else {
            #expect(false, "Expected .ready state but got \(state)")
        }
    }

//    @Test func givenCharacter_whenDidSelectCharacter_thenRouterNavigatesToDetails() {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        let character = CharacterUIModel(id: 42, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])
//
//        // when
//        sut.didSelectCharacter(character)
//
//        // then
//        #expect(router.didNavigateToRoute.called)
//        #expect(router.didNavigateToRoute.route == .details(characterId: 42))
//    }
//
//    @Test func givenNoParams_whenDidTapFilterButton_thenRouterNavigatesToFilter() {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        // when
//        sut.didTapFilterButton()
//        // then
//        #expect(router.didNavigateToRoute.called)
//        #expect(router.didNavigateToRoute.route == .filter)
//    }
//
//    @Test func givenCharacters_whenDidTapResetButton_thenSearchTextIsClearedAndAllCharactersLoaded() async {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        sut.searchText = "abc"
//        let expectedCharacters = [Character(id: 1, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])]
//        getAllCharactersUseCase.executeResult = .success(expectedCharacters)
//        // when
//        await sut.didTapResetButton()
//        // then
//        #expect(sut.searchText == "")
//        let state = await sut.state
//        if case let .ready(characters, _) = state {
//            #expect(characters.count == 1)
//        } else {
//            #expect(false, "Expected .ready state")
//        }
//    }
//
//    @Test func givenShortSearchText_whenDidSearchTextChanged_thenLoadsAllCharacters() async {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        sut.searchText = "ab" // less than minSearchChars
//        let expectedCharacters = [Character(id: 1, name: "Test", thumbnail: "", age: 10, weight: 20, height: 30, hairColor: "", professions: [], friends: [])]
//        getAllCharactersUseCase.executeResult = .success(expectedCharacters)
//        // when
//        await sut.didSearchTextChanged()
//        // then
//        let state = await sut.state
//        if case let .ready(characters, _) = state {
//            #expect(characters.count == 1)
//        } else {
//            #expect(false, "Expected .ready state")
//        }
//    }
//
//    @Test func givenLongSearchText_whenDidSearchTextChanged_thenSearchesCharacters() async {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        sut.searchText = "abcd" // >= minSearchChars
//        let expectedCharacters = [Character(id: 2, name: "Searched", thumbnail: "", age: 20, weight: 40, height: 60, hairColor: "", professions: [], friends: [])]
//        getSearchedCharacterUseCase.executeResult = .success(expectedCharacters)
//        // when
//        await sut.didSearchTextChanged()
//        // then
//        let state = await sut.state
//        if case let .ready(characters, _) = state {
//            #expect(characters.count == 1)
//            #expect(characters.first?.id == 2)
//        } else {
//            #expect(false, "Expected .ready state")
//        }
//    }
//
//    @Test func givenCharacters_whenDidRefreshCharacters_thenSearchTextIsClearedAndAllCharactersLoadedWithForceUpdate() async {
//        // given
//        let router = RouterMock()
//        let getAllCharactersUseCase = GetAllCharactersUseCaseMock()
//        let getActiveFilterUseCase = GetActiveFilterUseCaseMock()
//        let getFilteredCharactersUseCase = GetFilteredCharactersUseCaseMock()
//        let deleteActiveFilterUseCase = DeleteActiveFilterUseCaseMock()
//        let getSearchedCharacterUseCase = GetSearchedCharacterUseCaseMock()
//        let sut = HomeViewModel(
//            router: router,
//            getAllCharactersUseCase: getAllCharactersUseCase,
//            getActiveFilterUseCase: getActiveFilterUseCase,
//            getFilteredCharactersUseCase: getFilteredCharactersUseCase,
//            deleteActiveFilterUseCase: deleteActiveFilterUseCase,
//            getSearchedCharacterUseCase: getSearchedCharacterUseCase
//        )
//        sut.searchText = "abc"
//        let expectedCharacters = [Character(id: 3, name: "Refreshed", thumbnail: "", age: 30, weight: 60, height: 90, hairColor: "", professions: [], friends: [])]
//        getAllCharactersUseCase.executeResult = .success(expectedCharacters)
//        // when
//        await sut.didRefreshCharacters()
//        // then
//        #expect(sut.searchText == "")
//        let state = await sut.state
//        if case let .ready(characters, _) = state {
//            #expect(characters.count == 1)
//            #expect(characters.first?.id == 3)
//        } else {
//            #expect(false, "Expected .ready state")
//        }
//    }
}
