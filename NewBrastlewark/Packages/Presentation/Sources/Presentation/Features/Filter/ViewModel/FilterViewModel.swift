import Domain
import SwiftUI

public enum FilterState {
    case ready(FilterUIModel)
}

@MainActor
public protocol FilterViewModelProtocol: ObservableObject {
    // Outputs
    var state: FilterState { get }

    // Inputs
    func didViewLoad()
    func didChangeAge(_ age: ClosedRange<Int>)
    func didChangeWeight(_ weight: ClosedRange<Int>)
    func didChangeHeight(_ height: ClosedRange<Int>)
    func didChangeFriends(_ friends: ClosedRange<Int>)
    func didTapApplyButton()
    func didTapCancelButton()
}

@MainActor
public final class FilterViewModel: FilterViewModelProtocol {
    @Published public var state: FilterState = .ready(FilterUIModel())

    private let getAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol
    private let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol
    private let saveActiveFilterUseCase: SaveActiveFilterUseCaseProtocol

    // MARK: - Public methods

    public init(
        getAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol,
        getActiveFilterUseCase: GetActiveFilterUseCaseProtocol,
        saveActiveFilterUseCase: SaveActiveFilterUseCaseProtocol) {
            self.getAvailableFilterUseCase = getAvailableFilterUseCase
            self.getActiveFilterUseCase = getActiveFilterUseCase
            self.saveActiveFilterUseCase = saveActiveFilterUseCase
        }

    public func didViewLoad() {
        let getAvailableFilterUseCase = self.getAvailableFilterUseCase
        let getActiveFilterUseCase = self.getActiveFilterUseCase
        Task {
            async let availableResult = getAvailableFilterUseCase.execute()
            async let activeResult = getActiveFilterUseCase.execute()
            let (available, active) = await (availableResult, activeResult)
            
            switch (available, active) {
            case (.success(let availableFilter), .success(let activeFilter)):
                self.state = .ready(FilterUIModel(
                    available: FilterMapper.map(model: availableFilter),
                    active: FilterMapper.map(model: activeFilter ?? Filter())))
            default:
                self.state = .ready(FilterUIModel())
            }
        }
    }

    public func didChangeAge(_ age: ClosedRange<Int>) {
        // TODO: implement
    }

    public func didChangeWeight(_ weight: ClosedRange<Int>) {
        // TODO: implement
    }

    public func didChangeHeight(_ height: ClosedRange<Int>) {
        // TODO: implement
    }

    public func didChangeFriends(_ friends: ClosedRange<Int>) {
        // TODO: implement
    }

    public func didTapApplyButton() {
        // TODO: implement
    }

    public func didTapCancelButton() {
        // TODO: implement
    }
}
