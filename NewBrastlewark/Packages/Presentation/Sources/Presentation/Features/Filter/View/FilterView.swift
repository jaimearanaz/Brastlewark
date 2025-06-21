import SwiftUI

public struct FilterView<ViewModel: FilterViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    private var localizables = Localizables()

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle(localizables.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolbarButtons
                }
            }
            .task {
                viewModel.didViewLoad()
            }
        }
    }
}

private extension FilterView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .ready(let filter):
            EmptyView()
        }
    }

    var toolbarButtons: some View {
        HStack(spacing: 16) {
            Button(localizables.apply) {
                viewModel.didTapApplyButton()
            }
            Button(localizables.cancel) {
                viewModel.didTapCancelButton()
            }
        }
    }
}

private extension FilterView {
    struct Localizables {
        let title = "FILTER_TITLE".localized
        let apply = "FILTER_APPLY_BUTTON".localized
        let cancel = "FILTER_CANCEL_BUTTON".localized
        let age = "FILTER_SLIDER_AGE".localized
        let weight = "FILTER_SLIDER_WEIGHT".localized
        let height = "FILTER_SLIDER_HEIGHT".localized
        let friends = "FILTER_SLIDER_FRIENDS".localized
    }
}

// MARK: - Previews

#Preview("No filter active") {
    FilterView(viewModel: FilterViewModel.noFilterActive)
}

#Preview("Filter active") {
    FilterView(viewModel: FilterViewModel.filterActive)
}
