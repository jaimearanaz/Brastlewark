import Domain
import SwiftUI

public enum FilterState: Sendable {
    case loading
    case ready(FilterUIModel)
}

@MainActor
public protocol FilterDelegate: AnyObject {
    func filterDidChangeAndApply()
}

@MainActor
public protocol FilterViewModelProtocol: ObservableObject {
    // Outputs
    var state: FilterState { get }

    // Inputs
    func viewIsReady()
    func didChangeAge(_ age: ClosedRange<Int>)
    func didChangeWeight(_ weight: ClosedRange<Int>)
    func didChangeHeight(_ height: ClosedRange<Int>)
    func didChangeHairColor(title: String, checked: Bool)
    func didResetHairColor()
    func didChangeProfession(title: String, checked: Bool)
    func didResetProfession()
    func didChangeFriends(_ friends: ClosedRange<Int>)
    func didTapApplyButton()
    func didTapResetButton()
}

@MainActor
public final class FilterViewModel: FilterViewModelProtocol {
    @Published public var state: FilterState = .loading
    public weak var delegate: (any FilterDelegate)?

    private var hasChanges = false
    private var tasks = Set<Task<Void, Never>>()
    private let router: any RouterProtocol
    private let tracker: FilterTrackerProtocol
    private let getAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol
    private let getActiveFilterUseCase: GetActiveFilterUseCaseProtocol
    private let saveActiveFilterUseCase: SaveActiveFilterUseCaseProtocol

    // MARK: - Public methods

    public init(
        router: any RouterProtocol,
        tracker: FilterTrackerProtocol,
        getAvailableFilterUseCase: GetAvailableFilterUseCaseProtocol,
        getActiveFilterUseCase: GetActiveFilterUseCaseProtocol,
        saveActiveFilterUseCase: SaveActiveFilterUseCaseProtocol,
        delegate: (any FilterDelegate)? = nil) {
            self.router = router
            self.tracker = tracker
            self.getAvailableFilterUseCase = getAvailableFilterUseCase
            self.getActiveFilterUseCase = getActiveFilterUseCase
            self.saveActiveFilterUseCase = saveActiveFilterUseCase
            self.delegate = delegate
        }

    deinit {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }

    public func viewIsReady() {
        log("view ready, loading available and active filters", .viewModel, .debug)
        let getAvailableFilterUseCase = self.getAvailableFilterUseCase
        let getActiveFilterUseCase = self.getActiveFilterUseCase
        tracker.track(event: .screenViewed)
        let task = Task {
            async let availableResult = getAvailableFilterUseCase.execute()
            async let activeResult = getActiveFilterUseCase.execute()
            let (available, active) = await (availableResult, activeResult)

            hasChanges = false
            switch (available, active) {
            case (.success(let availableFilter), .success(let activeFilter)):
                self.state = .ready(Filter.map(
                    available: availableFilter,
                    active: activeFilter ?? defaultActiveFilter(available: availableFilter)))
            default:
                self.state = .ready(FilterUIModel())
            }
        }
        tasks.insert(task)
    }

    public func didChangeAge(_ age: ClosedRange<Int>) {
        log("age changed, lower: \(age.lowerBound), upper: \(age.upperBound)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .ageChanged(age: age))
        filter.age.active = age
        state = .ready(filter)
        hasChanges = true
    }

    public func didChangeWeight(_ weight: ClosedRange<Int>) {
        log("weight changed, lower: \(weight.lowerBound), upper: \(weight.upperBound)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .weightChanged(weight: weight))
        filter.weight.active = weight
        state = .ready(filter)
        hasChanges = true
    }

    public func didChangeHeight(_ height: ClosedRange<Int>) {
        log("height changed, lower: \(height.lowerBound), upper: \(height.upperBound)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .heightChanged(height: height))
        filter.height.active = height
        state = .ready(filter)
        hasChanges = true
    }

    public func didChangeHairColor(title: String, checked: Bool) {
        log("hair color changed, selected: \(checked), value: \(title)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        if let index = filter.hairColor.firstIndex(where: { $0.title == title }) {
            filter.hairColor[index].checked = checked
            tracker.track(event: .hairColorChanged(title: title, checked: checked))
            state = .ready(filter)
            hasChanges = true
        }
    }

    public func didResetHairColor() {
        log("hair colors reset", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .hairColorReset)
        for index in filter.hairColor.indices {
            filter.hairColor[index].checked = false
        }
        state = .ready(filter)
        hasChanges = true
    }

    public func didChangeProfession(title: String, checked: Bool) {
        log("profession changed, selected: \(checked), value: \(title)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        if let index = filter.profession.firstIndex(where: { $0.title == title }) {
            filter.profession[index].checked = checked
            tracker.track(event: .professionChanged(title: title, checked: checked))
            state = .ready(filter)
            hasChanges = true
        }
    }

    public func didResetProfession() {
        log("professions reset", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .professionReset)
        for index in filter.profession.indices {
            filter.profession[index].checked = false
        }
        state = .ready(filter)
        hasChanges = true
    }

    public func didChangeFriends(_ friends: ClosedRange<Int>) {
        log("friends changed, lower: \(friends.lowerBound), upper: \(friends.upperBound)", .interaction, .debug)
        guard case .ready(var filter) = state else {
            return
        }
        tracker.track(event: .friendsChanged(friends: friends))
        filter.friends.active = friends
        state = .ready(filter)
        hasChanges = true
    }

    public func didTapApplyButton() {
        log("apply button tapped", .interaction, .debug)
        guard hasChanges, case .ready(let filter) = state else {
            return
        }
        tracker.track(event: .applyTapped)
        let activeFilter = FilterUIModel.map(model: filter)
        let saveActiveFilterUseCase = saveActiveFilterUseCase
        log("saving active filter", .viewModel, .debug)
        let task = Task {
            let result = await saveActiveFilterUseCase.execute(params: .init(filter: activeFilter))
            guard !Task.isCancelled else {
                return
            }
            guard case .success = result else {
                return
            }

            hasChanges = false
            delegate?.filterDidChangeAndApply()
            router.navigateBack()
        }
        tasks.insert(task)
    }

    public func didTapResetButton() {
        log("reset button tapped", .interaction, .debug)
        guard case .ready = state else {
            return
        }
        tracker.track(event: .resetTapped)
        let getAvailableFilterUseCase = self.getAvailableFilterUseCase
        let task = Task {
            let availableResult = await getAvailableFilterUseCase.execute()
            hasChanges = true
            switch availableResult {
            case (.success(let availableFilter)):
                self.state = .ready(Filter.map(
                    available: availableFilter,
                    active: defaultActiveFilter(available: availableFilter)))
            default:
                self.state = .ready(FilterUIModel())
            }
        }
        tasks.insert(task)
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

extension FilterViewModel: PresentationLoggable {
    nonisolated static let logSource = "FilterViewModel"
}
