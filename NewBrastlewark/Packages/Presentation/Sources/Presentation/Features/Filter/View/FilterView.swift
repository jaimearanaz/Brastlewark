import SwiftUI
import MultiSlider

public struct FilterView<ViewModel: FilterViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var isApplyDisabled = true
    @State private var isHairColorSheetPresented = false
    @Environment(\.dismiss) private var dismiss
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
            GeometryReader { geometry in
                let titles = [
                    localizables.age,
                    localizables.weight,
                    localizables.height,
                    localizables.friends
                ]
                let maxTitleWidth = titles
                    .map { $0.widthOfString(usingFont: .systemFont(ofSize: UIFont.labelFontSize)) }
                    .max() ?? 0

                VStack(spacing: 32) {
                    sliderView(
                        title: localizables.age,
                        available: filter.age.available,
                        active: filter.age.active,
                        titleWidth: maxTitleWidth,
                        callback: { viewModel.didChangeAge($0) }
                    )
                    sliderView(
                        title: localizables.weight,
                        available: filter.weight.available,
                        active: filter.weight.active,
                        titleWidth: maxTitleWidth,
                        callback: { viewModel.didChangeWeight($0) }
                    )
                    sliderView(
                        title: localizables.height,
                        available: filter.height.available,
                        active: filter.height.active,
                        titleWidth: maxTitleWidth,
                        callback: { viewModel.didChangeHeight($0) }
                    )
                    sliderView(
                        title: localizables.friends,
                        available: filter.friends.available,
                        active: filter.friends.active,
                        titleWidth: maxTitleWidth,
                        callback: { viewModel.didChangeFriends($0) }
                    )
                    hairColorRow(
                        title: localizables.hairColor,
                        items: filter.hairColor,
                        titleWidth: maxTitleWidth
                    )
                    Spacer()
                }
                .padding(.top, 32)
                .frame(width: geometry.size.width)
            }
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
        titleWidth: CGFloat,
        callback: @escaping (ClosedRange<Int>) -> Void
    ) -> some View {
        HStack(spacing: 16) {
            Text(title)
                .frame(width: titleWidth, alignment: .leading)
            MultiValueSlider(
                value: fieldBinding(active, callback: callback),
                minimumValue: CGFloat(available.lowerBound),
                maximumValue: CGFloat(available.upperBound),
                snapStepSize: 1,
                valueLabelPosition: .top,
                orientation: .horizontal,
                outerTrackColor: .lightGray
            )
            .frame(minHeight: 44, maxHeight: 44)
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

    @ViewBuilder
    func hairColorRow(title: String, items: [FilterItemListUIModel], titleWidth: CGFloat) -> some View {
        let font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        let buttonWidth = title.widthOfString(usingFont: font) + 16

        HStack(spacing: 16) {
            Button(action: { isHairColorSheetPresented = true }) {
                HStack(spacing: 16) {
                    Text(title)
                        .frame(width: buttonWidth, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(hairColorSummary(items: items))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .sheet(isPresented: $isHairColorSheetPresented) {
            FilterSheetView(
                title: localizables.hairColor,
                items: items,
                onToggle: { title, checked in
                    viewModel.didChangeHairColor(title: title, checked: checked)
                    isApplyDisabled = false
                },
                onReset: {
                    viewModel.didResetHairColor()
                    isApplyDisabled = false
                }
            )
        }
    }

    func hairColorSummary(items: [FilterItemListUIModel]) -> String {
        let selected = items.filter { $0.checked }
        if selected.isEmpty {
            return localizables.allHairColors
        } else {
            return selected.map { $0.title }.joined(separator: ", ")
        }
    }
}

private extension FilterView {
    struct Localizables {
        let title = "FILTER_TITLE".localized
        let apply = "FILTER_APPLY_BUTTON".localized
        let age = "FILTER_SLIDER_AGE".localized
        let weight = "FILTER_SLIDER_WEIGHT".localized
        let height = "FILTER_SLIDER_HEIGHT".localized
        let hairColor = "FILTER_HAIR_COLOR".localized
        let friends = "FILTER_SLIDER_FRIENDS".localized
        let allHairColors = "FILTER_ALL_HAIR_COLORS".localized
    }
}

// MARK: - Previews

#Preview("No filter active") {
    FilterView(viewModel: FilterViewModel.noFilterActive)
}

#Preview("Filter active") {
    FilterView(viewModel: FilterViewModel.filterActive)
}
