@testable import Presentation

@MainActor
final class FilterDelegateMock: FilterDelegate {
    private(set) var filterDidChangeAndApplyCalled = false

    func filterDidChangeAndApply() {
        filterDidChangeAndApplyCalled = true
    }
}
