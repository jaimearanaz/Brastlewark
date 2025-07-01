import SwiftUI
import MultiSlider

public struct DetailsView<ViewModel: DetailsViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var maxTitleWidth: CGFloat = 0
    @State private var characterId: Int = 0
    private var localizables = Localizables()

    public init(characterId: Int = 0, viewModel: ViewModel) {
        self.characterId = characterId
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        content
            .navigationTitle(localizables.title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.characterId = characterId
                viewModel.didViewLoad()
            }
    }
}

private extension DetailsView {
    @ViewBuilder
    var content: some View {
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
                        detailsImage(details: details, geometry: geometry)
                        detailsName(details: details)
                        detailsInfo(details: details)
                        if !details.friends.isEmpty {
                            detailsFriends(details: details)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder
    func detailsImage(details: DetailsUIModel, geometry: GeometryProxy) -> some View {
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
    }

    func detailsName(details: DetailsUIModel) -> some View {
        Text(details.name)
            .font(.system(size: 32, weight: .bold))
            .padding(.horizontal)
    }

    func detailsInfo(details: DetailsUIModel) -> some View {
        let rows: [(String, String)] = [
            (localizables.age, "\(details.age)"),
            (localizables.weight, String(format: "%.1f", details.weight)),
            (localizables.height, String(format: "%.1f", details.height)),
            (localizables.hairColor, details.hairColor),
            (localizables.professions, details.professions.joined(separator: ", ")),
            (localizables.friends, details.friends.isEmpty ? localizables.noFriends : "")
        ]

        return ZStack {
            VStack {
                ForEach(rows, id: \.0) { title, _ in
                    Text(title)
                        .fontWeight(.bold)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        if geo.size.width > maxTitleWidth {
                                            maxTitleWidth = geo.size.width
                                        }
                                    }
                            }
                        )
                        .hidden()
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                ForEach(rows, id: \.0) { title, value in
                    detailRow(title: title, value: value, titleWidth: maxTitleWidth)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func detailRow(title: String, value: String, titleWidth: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title)
                .fontWeight(.bold)
                .frame(width: titleWidth, alignment: .leading)
            if title == localizables.friends && value == localizables.noFriends {
                Text(value)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray)
            } else {
                Text(value)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func detailsFriends(details: DetailsUIModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(details.friends, id: \.id) { friend in
                    FriendCell(friend: friend)
                        .onTapGesture {
                            viewModel.didSelectCharacter(friend.id)
                        }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

private extension DetailsView {
    struct Localizables {
        let title = "DETAILS_TITLE".localized
        let error = "DETAILS_ERROR_GENERAL".localized
        let age = "DETAILS_AGE".localized
        let weight = "DETAILS_WEIGHT".localized
        let height = "DETAILS_HEIGHT".localized
        let hairColor = "DETAILS_HAIR_COLOR".localized
        let professions = "DETAILS_PROFESSIONS".localized
        let friends = "DETAILS_FRIENDS".localized
        let noFriends = "DETAILS_NO_FRIENDS".localized
    }
}

#Preview("Ready") {
    DetailsView(viewModel: DetailsViewModel.ready)
}

#Preview("No friends") {
    DetailsView(viewModel: DetailsViewModel.noFriends)
}
