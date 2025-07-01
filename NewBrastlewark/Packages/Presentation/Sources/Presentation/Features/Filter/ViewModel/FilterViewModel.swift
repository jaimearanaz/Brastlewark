import Domain
import SwiftUI

public enum FilterState: Sendable {
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
    func didChangeHairColor(title: String, checked: Bool)
    func didResetHairColor()
    func didChangeProfession(title: String, checked: Bool)
    func didResetProfession()
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
                self.state = .ready(Filter.map(
                    available: availableFilter,
                    active: activeFilter ?? defaultActiveFilter(available: availableFilter)))
            default:
                self.state = .ready(FilterUIModel())
            }
        }
    }

    public func didChangeAge(_ age: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.age.active = age
        state = .ready(filter)
    }

    public func didChangeWeight(_ weight: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.weight.active = weight
        state = .ready(filter)
    }

    public func didChangeHeight(_ height: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.height.active = height
        state = .ready(filter)
    }

    public func didChangeHairColor(title: String, checked: Bool) {
        guard case .ready(var filter) = state else { return }
        if let index = filter.hairColor.firstIndex(where: { $0.title == title }) {
            filter.hairColor[index].checked = checked
            state = .ready(filter)
        }
    }

    public func didResetHairColor() {
        guard case .ready(var filter) = state else { return }
        for index in filter.hairColor.indices {
            filter.hairColor[index].checked = false
        }
        state = .ready(filter)
    }

    public func didChangeProfession(title: String, checked: Bool) {
        guard case .ready(var filter) = state else { return }
        if let index = filter.profession.firstIndex(where: { $0.title == title }) {
            filter.profession[index].checked = checked
            state = .ready(filter)
        }
    }

    public func didResetProfession() {
        guard case .ready(var filter) = state else { return }
        for index in filter.profession.indices {
            filter.profession[index].checked = false
        }
        state = .ready(filter)
    }

    public func didChangeFriends(_ friends: ClosedRange<Int>) {
        guard case .ready(var filter) = state else { return }
        filter.friends.active = friends
        state = .ready(filter)
    }

    public func didTapApplyButton() {
        guard case .ready(let filter) = state else { return }
        let activeFilter = FilterUIModel.map(model: filter)
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

private extension FilterViewModel {
    func defaultActiveFilter(available: Filter) -> Filter {
        .init(
            age: available.age,
            weight: available.weight,
            height: available.height,
            hairColor: [],
            profession: [],
            friends: available.friends
        )
    }
}
