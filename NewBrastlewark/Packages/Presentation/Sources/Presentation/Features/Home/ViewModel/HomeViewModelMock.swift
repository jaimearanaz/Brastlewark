import SwiftUI

final class HomeViewModelMock: HomeViewModelProtocol, ObservableObject {
    // Outputs
    @Published var state: HomeState
    @Published var searchText: String

    // Input callbacks
    var didOnAppearCallback: (() -> Void)?
    var didSelectCharacterCallback: ((CharacterUIModel) -> Void)?
    var didTapFilterButtonCallback: (() -> Void)?
    var didTapResetButtonCallback: (() -> Void)?
    var didSearchTextChangedCallback: (() -> Void)?
    var didRefreshCharactersCallback: (() -> Void)?

    init(
        state: HomeState = .loading,
        searchText: String = "",
        didOnAppearCallback: (() -> Void)? = nil,
        didSelectCharacterCallback: ((CharacterUIModel) -> Void)? = nil,
        didTapFilterButtonCallback: (() -> Void)? = nil,
        didTapResetButtonCallback: (() -> Void)? = nil,
        didSearchTextChangedCallback: (() -> Void)? = nil,
        didRefreshCharactersCallback: (() -> Void)? = nil
    ) {
        self.state = state
        self.searchText = searchText
        self.didOnAppearCallback = didOnAppearCallback
        self.didSelectCharacterCallback = didSelectCharacterCallback
        self.didTapFilterButtonCallback = didTapFilterButtonCallback
        self.didTapResetButtonCallback = didTapResetButtonCallback
        self.didSearchTextChangedCallback = didSearchTextChangedCallback
        self.didRefreshCharactersCallback = didRefreshCharactersCallback
    }

    // Inputs
    func didOnAppear() {
        didOnAppearCallback?()
    }
    func didSelectCharacter(_ character: CharacterUIModel) {
        didSelectCharacterCallback?(character)
    }
    func didTapFilterButton() {
        didTapFilterButtonCallback?()
    }
    func didTapResetButton() {
        didTapResetButtonCallback?()
    }
    func didSearchTextChanged() {
        didSearchTextChangedCallback?()
    }
    func didRefreshCharacters() {
        didRefreshCharactersCallback?()
    }
}
