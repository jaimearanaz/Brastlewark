import SwiftUI
import MultiSlider
import Utils

public struct FilterView<ViewModel: FilterViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var isApplyDisabled = true
    @State private var isHairSheetPresented = false
    @State private var isProfessionSheetPresented = false
    private var localizables = Localizables()
    private var accessibilityIds = AccessibilityIdentifiers()

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
            viewModel.viewIsReady()
        }
    }
}

// MARK: - Private methods

private extension FilterView {
    @ViewBuilder var content: some View {
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
                .accessibilityIdentifier(accessibilityIds.loadingView)
                .accessibilityLabel(localizables.loading)
        }
    }

    var toolbarButtons: some View {
        HStack(spacing: 16) {
            resetButton
            applyButton
        }
    }

    var resetButton: some View {
        Button(localizables.reset) {
            viewModel.didTapResetButton()
        }
        .accessibilityIdentifier(accessibilityIds.resetButton)
        .accessibilityLabel(localizables.reset)
        .accessibilityHint(localizables.resetHint)
    }

    var applyButton: some View {
        Button(localizables.apply) {
            viewModel.didTapApplyButton()
        }
        .disabled(isApplyDisabled)
        .accessibilityIdentifier(accessibilityIds.applyButton)
        .accessibilityLabel(localizables.apply)
        .accessibilityHint(localizables.applyHint)
        .accessibilityValue(isApplyDisabled ? localizables.deactive : localizables.active)
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
        .accessibilityElement()
        .accessibilityIdentifier(sliderAccessibilityIdentifier(for: title))
        .accessibilityLabel(title)
        .accessibilityValue("\(active.lowerBound) \(localizables.to) \(active.upperBound)")
        .accessibilityHint(localizables.adjustRange)
        .accessibilityAddTraits([.updatesFrequently])
        .accessibilityAdjustableAction { direction in
            var newLower = active.lowerBound
            var newUpper = active.upperBound
            let step = 1

            switch direction {
            case .increment:
                if newUpper < available.upperBound {
                    newUpper += step
                }
            case .decrement:
                if newLower > available.lowerBound {
                    newLower -= step
                }
            @unknown default:
                break
            }

            callback(newLower...newUpper)
            isApplyDisabled = false
        }
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

    // swiftlint:disable function_parameter_count
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
            Button {
                isSheetPresented.wrappedValue = true
            } label: {
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
            .accessibilityIdentifier(buttonAccessibilityIdentifier(for: title))
            .accessibilityLabel(title)
            .accessibilityValue(multipleFieldSummary(allTitle: allTitle, items: items))
            .accessibilityHint(localizables.selectOptions)
            .accessibilityAddTraits([.isButton, .updatesFrequently])
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
    // swiftlint:enable function_parameter_count

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

    func sliderAccessibilityIdentifier(for title: String) -> String {
        switch title {
        case localizables.age:
            return accessibilityIds.ageSlider
        case localizables.weight:
            return accessibilityIds.weightSlider
        case localizables.height:
            return accessibilityIds.heightSlider
        case localizables.friends:
            return accessibilityIds.friendsSlider
        default:
            return ""
        }
    }

    func buttonAccessibilityIdentifier(for title: String) -> String {
        switch title {
        case localizables.hairColor:
            return accessibilityIds.hairColorButton
        case localizables.profession:
            return accessibilityIds.professionButton
        default:
            return ""
        }
    }
}

// MARK: - Constants

private extension FilterView {
    struct Localizables {
        let title = "FILTER_TITLE".localized
        let apply = "FILTER_APPLY_BUTTON".localized
        let applyHint = "FILTER_APPLY_HINT".localized
        let reset = "FILTER_RESET_BUTTON".localized
        let resetHint = "FILTER_RESET_HINT".localized
        let age = "FILTER_SLIDER_AGE".localized
        let weight = "FILTER_SLIDER_WEIGHT".localized
        let height = "FILTER_SLIDER_HEIGHT".localized
        let hairColor = "FILTER_HAIR_COLOR".localized
        let profession = "FILTER_HAIR_PROFESSION".localized
        let friends = "FILTER_SLIDER_FRIENDS".localized
        let allHairColors = "FILTER_ALL_HAIR_COLORS".localized
        let allProfessions = "FILTER_ALL_PROFESSIONS".localized
        let to = "FILTER_TO".localized
        let adjustRange = "FILTER_ADJUST_RANGE".localized
        let selectOptions = "FILTER_SELECT_OPTIONS".localized
        let active = "ACTIVE".localized
        let deactive = "DEACTIVE".localized
        let loading = "LOADING".localized
    }

    struct AccessibilityIdentifiers {
        let applyButton = "filter.apply.button"
        let resetButton = "filter.reset.button"
        let ageSlider = "filter.age.slider"
        let weightSlider = "filter.weight.slider"
        let heightSlider = "filter.height.slider"
        let friendsSlider = "filter.friends.slider"
        let hairColorButton = "filter.hairColor.button"
        let professionButton = "filter.profession.button"
        let loadingView = "filter.loading.view"
    }
}

// MARK: - Previews

#Preview("No filter active") {
    FilterView(viewModel: FilterViewModelPreview.noFilterActive)
}

#Preview("Filter active") {
    FilterView(viewModel: FilterViewModelPreview.filterActive)
}
