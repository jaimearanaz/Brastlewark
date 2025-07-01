import SwiftUI
import MultiSlider

public struct FilterView<ViewModel: FilterViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var isApplyDisabled = true
    @State private var isHairSheetPresented = false
    @State private var isProfessionSheetPresented = false
    private var localizables = Localizables()

    // MARK: - Public methods

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            content
        }
        .navigationTitle(localizables.title)
        .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Private methods

private extension FilterView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .ready(let filter):
            GeometryReader { geometry in
                let (titleWidth, summaryWidth) = calculateMaxWidths(geometry: geometry, filter: filter)
                VStack(spacing: 32) {
                    sliderListView(filter: filter, maxTitleWidth: titleWidth)
                    hairColorView(filter: filter, maxTitleWidth: titleWidth, maxSummaryWidth: summaryWidth)
                    professionView(filter: filter, maxTitleWidth: titleWidth, maxSummaryWidth: summaryWidth)
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
    func sliderListView(filter: FilterUIModel, maxTitleWidth: CGFloat) -> some View {
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
    func hairColorView(filter: FilterUIModel, maxTitleWidth: CGFloat, maxSummaryWidth: CGFloat) -> some View {
        multipleFieldRow(
            title: localizables.hairColor,
            items: filter.hairColor,
            titleWidth: maxTitleWidth,
            summaryWidth: maxSummaryWidth,
            allTitle: localizables.allHairColors,
            isSheetPresented: $isHairSheetPresented,
            sheetTitle: localizables.hairColor,
            onToggle: { title, checked in
                viewModel.didChangeHairColor(title: title, checked: checked)
            },
            onReset: {
                viewModel.didResetHairColor()
            }
        )
    }

    @ViewBuilder
    func professionView(filter: FilterUIModel, maxTitleWidth: CGFloat, maxSummaryWidth: CGFloat) -> some View {
        multipleFieldRow(
            title: localizables.profession,
            items: filter.profession,
            titleWidth: maxTitleWidth,
            summaryWidth: maxSummaryWidth,
            allTitle: localizables.allProfessions,
            isSheetPresented: $isProfessionSheetPresented,
            sheetTitle: localizables.profession,
            onToggle: { title, checked in
                viewModel.didChangeProfession(title: title, checked: checked)
            },
            onReset: {
                viewModel.didResetProfession()
            }
        )
    }

    @ViewBuilder
    func multipleFieldRow(
        title: String,
        items: [FilterItemListUIModel],
        titleWidth: CGFloat,
        summaryWidth: CGFloat,
        allTitle: String,
        isSheetPresented: Binding<Bool>,
        sheetTitle: String,
        onToggle: @escaping (String, Bool) -> Void,
        onReset: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 16) {
            Button(action: { isSheetPresented.wrappedValue = true }) {
                HStack(spacing: 16) {
                    Text(title)
                        .foregroundColor(.accentColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(multipleFieldSummary(allTitle: allTitle, items: items))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .sheet(isPresented: isSheetPresented) {
            FilterSheetView(
                title: sheetTitle,
                items: items,
                onToggle: { title, checked in
                    onToggle(title, checked)
                    isApplyDisabled = false
                },
                onReset: {
                    onReset()
                    isApplyDisabled = false
                }
            )
        }
    }

    func multipleFieldSummary(allTitle: String, items: [FilterItemListUIModel]) -> String {
        let selected = items.filter { $0.checked }
        if selected.isEmpty {
            return allTitle
        } else {
            return selected.map { $0.title }.joined(separator: ", ")
        }
    }

    func calculateMaxWidths(
        geometry: GeometryProxy,
        filter: FilterUIModel) -> (maxTitleWidth: CGFloat, maxSummaryWidth: CGFloat) {
        let titles = [
            localizables.age,
            localizables.weight,
            localizables.height,
            localizables.friends,
            localizables.hairColor,
            localizables.profession
        ]
        let maxTitleWidth = titles
            .map { $0.widthOfString(usingFont: .systemFont(ofSize: UIFont.labelFontSize)) }
            .max() ?? 0

        let hairSummary = multipleFieldSummary(allTitle: localizables.allHairColors, items: filter.hairColor)
        let professionSummary = multipleFieldSummary(allTitle: localizables.allProfessions, items: filter.profession)
        let summaries = [hairSummary, professionSummary]
        let maxSummaryWidth = summaries
            .map { $0.widthOfString(usingFont: .systemFont(ofSize: UIFont.labelFontSize)) }
            .max() ?? 0
        return (maxTitleWidth, maxSummaryWidth)
    }
}

// MARK: - Constants

private extension FilterView {
    struct Localizables {
        let title = "FILTER_TITLE".localized
        let apply = "FILTER_APPLY_BUTTON".localized
        let age = "FILTER_SLIDER_AGE".localized
        let weight = "FILTER_SLIDER_WEIGHT".localized
        let height = "FILTER_SLIDER_HEIGHT".localized
        let hairColor = "FILTER_HAIR_COLOR".localized
        let profession = "FILTER_HAIR_PROFESSION".localized
        let friends = "FILTER_SLIDER_FRIENDS".localized
        let allHairColors = "FILTER_ALL_HAIR_COLORS".localized
        let allProfessions = "FILTER_ALL_PROFESSIONS".localized
    }
}

// MARK: - Previews

#Preview("No filter active") {
    FilterView(viewModel: FilterViewModel.noFilterActive)
}

#Preview("Filter active") {
    FilterView(viewModel: FilterViewModel.filterActive)
}
