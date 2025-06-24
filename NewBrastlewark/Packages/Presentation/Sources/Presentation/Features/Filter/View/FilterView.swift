import SwiftUI
import MultiSlider

public struct FilterView<ViewModel: FilterViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var isApplyDisabled = true
    private var localizables = Localizables()
    @Environment(\.dismiss) private var dismiss

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
                viewModel.dismiss = { dismiss() }
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
            VStack (spacing: 32) {
                sliderView(
                    title: localizables.age,
                    available: filter.available.age,
                    active: filter.active.age,
                    callback: { viewModel.didChangeAge($0) }
                )
                sliderView(
                    title: localizables.weight,
                    available: filter.available.weight,
                    active: filter.active.weight,
                    callback: { viewModel.didChangeWeight($0) }
                )
                sliderView(
                    title: localizables.height,
                    available: filter.available.height,
                    active: filter.active.height,
                    callback: { viewModel.didChangeHeight($0) }
                )
                sliderView(
                    title: localizables.friends,
                    available: filter.available.friends,
                    active: filter.active.friends,
                    callback: { viewModel.didChangeFriends($0) }
                )
                Spacer()
            }
            .padding(.top, 32)
        case .loading:
            ProgressView()
        }
    }

    var toolbarButtons: some View {
        HStack(spacing: 16) {
            Button(localizables.apply) {
                viewModel.didTapApplyButton()
            }
            .disabled(isApplyDisabled)
        }
    }

    @ViewBuilder
    func sliderView(
        title: String,
        available: ClosedRange<Int>,
        active: ClosedRange<Int>,
        callback: @escaping (ClosedRange<Int>) -> Void) -> some View {
            HStack(spacing: 16) {
                Text(title)
                MultiValueSlider(
                    value: fieldBinding(active, callback: callback),
                    minimumValue: CGFloat(available.lowerBound),
                    maximumValue: CGFloat(available.upperBound),
                    snapStepSize: 1,
                    valueLabelPosition: .top,
                    orientation: .horizontal,
                    outerTrackColor: .lightGray
                )
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            }
            .padding(.horizontal)
    }

    func fieldBinding(
        _ field: ClosedRange<Int>,
        callback: @escaping (ClosedRange<Int>) -> Void) -> Binding<[CGFloat]> {
        Binding<[CGFloat]>(
            get: {
                [CGFloat(field.lowerBound), CGFloat(field.upperBound)]
            },
            set: { newValue in
                guard newValue.count == 2 else { return }
                let newRange = Int(newValue[0])...Int(newValue[1])
                callback(newRange)
                isApplyDisabled = false
            }
        )
    }
}

private extension FilterView {
    struct Localizables {
        let title = "FILTER_TITLE".localized
        let apply = "FILTER_APPLY_BUTTON".localized
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
