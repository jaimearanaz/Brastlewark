import Domain
import SwiftUI

public enum FilterState {
    case loading
    case ready(FilterUIModel)
}

@MainActor
public protocol FilterViewModelProtocol: ObservableObject {
    // Outputs
    var state: FilterState { get }
    var dismiss: (() -> Void)? { get set } 

    // Inputs
    func didViewLoad()
    func didChangeAge(_ age: ClosedRange<Int>)
    func didChangeWeight(_ weight: ClosedRange<Int>)
    func didChangeHeight(_ height: ClosedRange<Int>)
    func didChangeFriends(_ friends: ClosedRange<Int>)
    func didTapApplyButton()
}

@MainActor
public final class FilterViewModel: FilterViewModelProtocol {
    @Published public var state: FilterState = .loading
    public var dismiss: (() -> Void)?

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
                    active: FilterMapper.map(model: activeFilter ?? availableFilter)))
            default:
                self.state = .ready(FilterUIModel())
            }
        }
    }

    public func didChangeAge(_ age: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.active.age = age
        state = .ready(filter)
    }

    public func didChangeWeight(_ weight: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.active.weight = weight
        state = .ready(filter)
    }

    public func didChangeHeight(_ height: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.active.height = height
        state = .ready(filter)
    }

    public func didChangeFriends(_ friends: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.active.friends = friends
        state = .ready(filter)
    }

    public func didTapApplyButton() {
        guard case .ready(let filter) = state else { return }
        let activeFilter = FilterUIModel.map(model: filter.active)
        let saveActiveFilterUseCase = saveActiveFilterUseCase
        Task {
            let result = await saveActiveFilterUseCase.execute(params: .init(filter: activeFilter))
            switch result {
            case .success:
                dismiss?()
            case .failure:
                break
                // TODO: implement error handling
            }
        }
    }
}
