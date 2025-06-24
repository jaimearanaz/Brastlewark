import SwiftUI

struct FilterSheetView: View {
    let title: String
    let items: [FilterItemListUIModel]
    let onToggle: (String, Bool) -> Void
    let onReset: () -> Void
    private let localizables = Localizables()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.title) { item in
                    Button(action: {
                        onToggle(item.title, !item.checked)
                    }) {
                        HStack {
                            Text(item.title)
                                .foregroundColor(.black)
                            Spacer()
                            if item.checked {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(localizables.reset) {
                        onReset()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localizables.accept) {
                        dismiss()
                    }
                }
            }
        }
    }
}

private extension FilterSheetView {
    struct Localizables {
        let reset = "FILTER_RESET_BUTTON".localized
        let accept = "FILTER_ACCEPT_BUTTON".localized
    }
}
