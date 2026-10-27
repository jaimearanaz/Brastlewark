import Domain
import Observation

@MainActor
@Observable
final class DetailsViewModelMock: DetailsViewModelProtocol {
    // Outputs
    var state: DetailsState
    var characterId: Int = 0

    // Input callbacks
    @ObservationIgnored var didViewLoadCallback: (() -> Void)?
    @ObservationIgnored var didSelectCharacterCallback: ((Int) -> Void)?
    @ObservationIgnored var didTapHomeButtonCallback: (() -> Void)?

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
