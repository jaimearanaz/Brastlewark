import Combine
import Domain
import Foundation

@MainActor
final class FilterViewModelMock: FilterViewModelProtocol, ObservableObject {
    // Outputs
    @Published var state: FilterState
    var dismiss: (() -> Void)?

    // Input callbacks
    var didViewLoadCallback: (() -> Void)?
    var didChangeAgeCallback: ((ClosedRange<Int>) -> Void)?
    var didChangeWeightCallback: ((ClosedRange<Int>) -> Void)?
    var didChangeHeightCallback: ((ClosedRange<Int>) -> Void)?
    var didChangeFriendsCallback: ((ClosedRange<Int>) -> Void)?
    var didTapApplyButtonCallback: (() -> Void)?
    var didTapCancelButtonCallback: (() -> Void)?

    init(
        state: FilterState = .ready(FilterUIModel()),
        dismiss: (() -> Void)? = nil,
        didViewLoadCallback: (() -> Void)? = nil,
        didChangeAgeCallback: ((ClosedRange<Int>) -> Void)? = nil,
        didChangeWeightCallback: ((ClosedRange<Int>) -> Void)? = nil,
        didChangeHeightCallback: ((ClosedRange<Int>) -> Void)? = nil,
        didChangeFriendsCallback: ((ClosedRange<Int>) -> Void)? = nil,
        didTapApplyButtonCallback: (() -> Void)? = nil,
        didTapCancelButtonCallback: (() -> Void)? = nil) {
        self.state = state
        self.dismiss = dismiss
        self.didViewLoadCallback = didViewLoadCallback
        self.didChangeAgeCallback = didChangeAgeCallback
        self.didChangeWeightCallback = didChangeWeightCallback
        self.didChangeHeightCallback = didChangeHeightCallback
        self.didChangeFriendsCallback = didChangeFriendsCallback
        self.didTapApplyButtonCallback = didTapApplyButtonCallback
        self.didTapCancelButtonCallback = didTapCancelButtonCallback
    }

    // Inputs
    func didViewLoad() {
        didViewLoadCallback?()
    }
    func didChangeAge(_ age: ClosedRange<Int>) {
        didChangeAgeCallback?(age)
    }
    func didChangeWeight(_ weight: ClosedRange<Int>) {
        didChangeWeightCallback?(weight)
    }
    func didChangeHeight(_ height: ClosedRange<Int>) {
        didChangeHeightCallback?(height)
    }
    func didChangeFriends(_ friends: ClosedRange<Int>) {
        didChangeFriendsCallback?(friends)
    }
    func didTapApplyButton() {
        didTapApplyButtonCallback?()
    }
    func didTapCancelButton() {
        didTapCancelButtonCallback?()
    }
}
