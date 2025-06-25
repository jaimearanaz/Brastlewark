import SwiftUI
import Domain

@MainActor
final class DetailsViewModelMock: DetailsViewModelProtocol, ObservableObject {
    // Outputs
    @Published var state: DetailsState

    // Input callbacks
    var didViewLoadCallback: (() -> Void)?
    var didSelectCharacterCallback: ((String) -> Void)?

    init(
        state: DetailsState = .loading,
        didViewLoadCallback: (() -> Void)? = nil,
        didSelectCharacterCallback: ((String) -> Void)? = nil) {
        self.state = state
        self.didViewLoadCallback = didViewLoadCallback
        self.didSelectCharacterCallback = didSelectCharacterCallback
    }

    // Inputs
    func didViewLoad() {
        didViewLoadCallback?()
    }

    func didSelectCharacter(_ id: String) {
        didSelectCharacterCallback?(id)
    }
}
