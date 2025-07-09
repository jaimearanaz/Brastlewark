import SwiftUI
import Domain

@MainActor
final class DetailsViewModelMock: DetailsViewModelProtocol, ObservableObject {
    // Outputs
    @Published var state: DetailsState
    var characterId: Int = 0

    // Input callbacks
    var didViewLoadCallback: (() -> Void)?
    var didSelectCharacterCallback: ((Int) -> Void)?
    var didTapHomeButtonCallback: (() -> Void)?

    init(
        state: DetailsState = .loading,
        didViewLoadCallback: (() -> Void)? = nil,
        didSelectCharacterCallback: ((Int) -> Void)? = nil) {
        self.state = state
        self.didViewLoadCallback = didViewLoadCallback
        self.didSelectCharacterCallback = didSelectCharacterCallback
    }

    // Inputs
    func viewIsReady() {
        didViewLoadCallback?()
    }

    func didSelectCharacter(_ id: Int) {
        didSelectCharacterCallback?(id)
    }

    func didTapHomeButton() {
        didTapHomeButtonCallback?()
    }
}
