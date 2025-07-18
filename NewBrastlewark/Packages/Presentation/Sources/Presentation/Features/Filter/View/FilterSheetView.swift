import SwiftUI

struct FilterSheetView: View {
    let title: String
    let items: [FilterItemListUIModel]
    let onToggle: (String, Bool) -> Void
    let onReset: () -> Void
    private let localizables = Localizables()
    private let accessibilityIds = AccessibilityIdentifiers()
    private let constants = Constants()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        toolbarButtons
                    }
                }
        }
    }
}

// MARK: - Private methods

private extension FilterSheetView {
    var content: some View {
        List {
            ForEach(items, id: \.id) { item in
                itemView(for: item)
            }
        }
        .accessibilityIdentifier(accessibilityIds.filterList)
    }

    func itemView(for item: FilterItemListUIModel) -> some View {
        Button(action: {
            onToggle(item.title, !item.checked)
        }) {
            HStack {
                Text(item.title)
                    .foregroundColor(Color.primary)
                Spacer()
                if item.checked {
                    Image(systemName: constants.checkmarkImage)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .accessibilityIdentifier("\(accessibilityIds.filterOption).\(item.id)")
        .accessibilityLabel(item.title)
        .accessibilityValue(item.checked ? localizables.selected : localizables.notSelected)
        .accessibilityHint(localizables.toggleHint)
        .accessibilityAddTraits(.isButton)
    }

    var toolbarButtons: some View {
        HStack (spacing: 16) {
            resetButton
            acceptButton
        }
    }

    var resetButton: some View {
        Button(localizables.reset) {
            onReset()
        }
        .accessibilityIdentifier(accessibilityIds.resetButton)
        .accessibilityLabel(localizables.reset)
        .accessibilityHint(localizables.resetHint)
    }

    var acceptButton: some View {
        Button(localizables.accept) {
            dismiss()
        }
        .accessibilityIdentifier(accessibilityIds.acceptButton)
        .accessibilityLabel(localizables.accept)
        .accessibilityHint(localizables.acceptHint)
    }
}

// MARK: - Constants

private extension FilterSheetView {
    struct Constants {
        let checkmarkImage = "checkmark"
    }

    struct Localizables {
        let reset = "FILTER_RESET_BUTTON".localized
        let accept = "FILTER_ACCEPT_BUTTON".localized
        let selected = "FILTER_OPTION_SELECTED".localized
        let notSelected = "FILTER_OPTION_NOT_SELECTED".localized
        let toggleHint = "FILTER_OPTION_TOGGLE_HINT".localized
        let resetHint = "FILTER_RESET_HINT".localized
        let acceptHint = "FILTER_ACCEPT_HINT".localized
    }

    struct AccessibilityIdentifiers {
        let filterOption = "filter.option"
        let filterList = "filter.list"
        let resetButton = "filter.reset.button"
        let acceptButton = "filter.accept.button"
    }
}

// MARK: - Previews

#Preview("Hair Colors") {
    FilterSheetView(
        title: "Hair Color",
        items: FilterSheetViewPreview.hairColors,
        onToggle: { _, _ in },
        onReset: { }
    )
}

#Preview("Professions") {
    FilterSheetView(
        title: "Profession",
        items: FilterSheetViewPreview.professions,
        onToggle: { _, _ in },
        onReset: { }
    )
}

private struct FilterSheetViewPreview {
    static let hairColors: [FilterItemListUIModel] = [
        .init(title: "Red", checked: true),
        .init(title: "Pink", checked: false),
        .init(title: "Green", checked: true),
        .init(title: "Black", checked: false),
        .init(title: "Gray", checked: false)
    ]

    static let professions: [FilterItemListUIModel] = [
        .init(title: "Metalworker", checked: true),
        .init(title: "Woodcarver", checked: true),
        .init(title: "Stonecarver", checked: false),
        .init(title: "Brewer", checked: false),
        .init(title: "Baker", checked: false),
        .init(title: "Farmer", checked: true)
    ]
}
