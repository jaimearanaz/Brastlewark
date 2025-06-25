import SwiftUI
import Domain

@MainActor
final class DetailsViewModelMock: DetailsViewModelProtocol, ObservableObject {
    // Outputs
    @Published var state: DetailsState

    // Input callbacks
    var didOnAppearCallback: (() -> Void)?
    var didSelectCharacterCallback: ((String) -> Void)?

    init(
        state: DetailsState = .loading,
        didOnAppearCallback: (() -> Void)? = nil,
        didSelectCharacterCallback: ((String) -> Void)? = nil) {
        self.state = state
        self.didOnAppearCallback = didOnAppearCallback
        self.didSelectCharacterCallback = didSelectCharacterCallback
    }

    // Inputs
    func didOnAppear() {
        didOnAppearCallback?()
    }

    func didSelectCharacter(_ id: String) {
        didSelectCharacterCallback?(id)
    }
}
