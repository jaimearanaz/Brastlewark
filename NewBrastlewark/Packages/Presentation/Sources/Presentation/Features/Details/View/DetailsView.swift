import SwiftUI
import MultiSlider

public struct DetailsView<ViewModel: DetailsViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    private var localizables = Localizables()

    // MARK: - Public methods

    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        content
            .navigationTitle(localizables.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.didOnAppear()
            }
    }
}

// MARK: - Private methods

private extension DetailsView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error:
            Text(localizables.error)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .ready(let details):
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Thumbnail
                        if !details.thumbnail.isEmpty, let url = URL(string: details.thumbnail) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height * 0.25
                            )
                            .clipped()
                        }

                        // Name
                        Text(details.name)
                            .font(.system(size: 32, weight: .bold))
                            .padding(.horizontal)

                        // Details
                        VStack(alignment: .leading, spacing: 16) {
                            detailRow(title: localizables.age, value: "\(details.age)")
                            detailRow(title: localizables.weight, value: String(format: "%.1f", details.weight))
                            detailRow(title: localizables.height, value: String(format: "%.1f", details.height))
                            detailRow(title: localizables.hairColor, value: details.hairColor)
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(title)
                .fontWeight(.bold)
                .frame(minWidth: 90, alignment: .leading)
            Text(value)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

// MARK: - Constants

private extension DetailsView {
    struct Localizables {
        let title = "DETAILS_TITLE".localized
        let error = "DETAILS_ERROR_GENERAL".localized
        let age = "DETAILS_AGE".localized
        let weight = "DETAILS_WEIGHT".localized
        let height = "DETAILS_HEIGHT".localized
        let hairColor = "DETAILS_HAIR_COLOR".localized
    }
}

// MARK: - Previews

#Preview("Ready") {
    DetailsView(viewModel: DetailsViewModel.ready)
    
}
