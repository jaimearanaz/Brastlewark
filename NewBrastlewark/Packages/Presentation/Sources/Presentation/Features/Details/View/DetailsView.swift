import SwiftUI
import MultiSlider
import Utils

public struct DetailsView<ViewModel: DetailsViewModelProtocol & ObservableObject>: View {
    @StateObject private var viewModel: ViewModel
    @State private var maxTitleWidth: CGFloat = 0
    @State private var characterId: Int = 0
    @State private var showHome: Bool = false
    private var localizables = Localizables()
    private var accessibilityIds = AccessibilityIdentifiers()
    private var constants = Constants()

    public init(characterId: Int = 0, showHome: Bool = false, viewModel: ViewModel) {
        self.characterId = characterId
        self.showHome = showHome
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        content
            .navigationTitle(localizables.title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.characterId = characterId
                viewModel.viewIsReady()
            }
    }
}

private extension DetailsView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .error:
            errorView
        case .ready(let details):
            readyView(details: details)
        }
    }

    var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier(accessibilityIds.loadingView)
            .accessibilityLabel(localizables.loading)
            .accessibilityAddTraits(.updatesFrequently)
    }

    var errorView: some View {
        Text(localizables.error)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier(accessibilityIds.errorView)
            .accessibilityLabel(localizables.error)
            .accessibilityAddTraits(.isStaticText)
    }

    func readyView(details: DetailsUIModel) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    detailsImage(details: details, geometry: geometry)
                    detailsName(details: details)
                    detailsInfo(details: details)
                    if !details.friends.isEmpty {
                        detailsFriends(details: details)
                    }
                    homeButton
                        .padding(.top, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .accessibilityIdentifier(accessibilityIds.detailsScroll)
        }
    }

    @ViewBuilder
    var homeButton: some View {
        if showHome {
            Button(action: {
                viewModel.didTapHomeButton()
            }) {
                Text(localizables.backHome)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .accessibilityIdentifier(accessibilityIds.homeButton)
            .accessibilityLabel(localizables.backHome)
            .accessibilityHint(localizables.backHomeHint)
        }
    }

    @ViewBuilder
    func detailsImage(details: DetailsUIModel, geometry: GeometryProxy) -> some View {
        if !details.thumbnail.isEmpty, let url = URL(string: details.thumbnail) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .accessibilityIdentifier(accessibilityIds.characterImageLoading)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accessibilityIdentifier(accessibilityIds.characterImageSuccess)
                case .failure:
                    fallbackImage()
                        .accessibilityIdentifier(accessibilityIds.characterImageFailure)
                @unknown default:
                    fallbackImage()
                        .accessibilityIdentifier(accessibilityIds.characterImageDefault)
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height * 0.25
            )
            .clipped()
            .accessibilityIdentifier(accessibilityIds.characterImage)
            .accessibilityLabel("\(localizables.imageOf) \(details.name)")
            .accessibilityAddTraits(.isImage)
        }
    }

    func fallbackImage() -> some View {
        Image(systemName: constants.defaultImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(.gray)
    }

    func detailsName(details: DetailsUIModel) -> some View {
        Text(details.name)
            .font(.system(size: 32, weight: .bold))
            .padding(.horizontal)
            .accessibilityIdentifier(accessibilityIds.characterName)
            .accessibilityAddTraits(.isHeader)
    }

    func detailsRows(forDetails details: DetailsUIModel) -> [(String, String, String)] {
        [(localizables.age, "\(details.age)", accessibilityIds.ageRow),
        (localizables.weight, String(format: "%.1f", details.weight), accessibilityIds.weightRow),
        (localizables.height, String(format: "%.1f", details.height), accessibilityIds.heightRow),
        (localizables.hairColor, details.hairColor, accessibilityIds.hairColorRow),
        (localizables.professions, details.professions.joined(separator: ", "), accessibilityIds.professionsRow),
        (localizables.friends, details.friends.isEmpty ? localizables.noFriends : "", accessibilityIds.friendsRow)]
    }

    func detailsInfo(details: DetailsUIModel) -> some View {
        let rows = detailsRows(forDetails: details)
        return ZStack {
            VStack {
                ForEach(rows, id: \.0) { title, _, _ in
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
                ForEach(rows, id: \.0) { title, value, accessibilityId in
                    detailRow(
                        title: title,
                        value: value,
                        titleWidth: maxTitleWidth,
                        accessibilityId: accessibilityId)
                }
            }
            .padding(.horizontal)
            .accessibilityIdentifier(accessibilityIds.infoSection)
        }
    }

    @ViewBuilder
    func detailRow(title: String, value: String, titleWidth: CGFloat, accessibilityId: String) -> some View {
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
        .accessibilityElement()
        .accessibilityIdentifier(accessibilityId)
        .accessibilityLabel("\(title): \(value)")
        .accessibilityAddTraits(.isStaticText)
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
                        .accessibilityIdentifier("\(accessibilityIds.friend).\(friend.id)")
                        .accessibilityAddTraits(.isButton)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .accessibilityIdentifier(accessibilityIds.friendsSection)
    }
}

private extension DetailsView {
    struct Constants {
        let defaultImage = "person.circle.fill"
    }

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
        let backHome = "DETAILS_BACK_HOME".localized
        let backHomeHint = "DETAILS_BACK_HOME_HINT".localized
        let loading = "LOADING".localized
        let imageOf = "DETAILS_IMAGE_OF".localized
    }

    struct AccessibilityIdentifiers {
        let loadingView = "details.loading.view"
        let errorView = "details.error.view"
        let characterImage = "details.character.image"
        let characterImageLoading = "details.character.image.loading"
        let characterImageSuccess = "details.character.image.success"
        let characterImageFailure = "details.character.image.failure"
        let characterImageDefault = "details.character.image.default"
        let characterName = "details.character.name"
        let detailsScroll = "details.scroll"
        let infoSection = "details.info.section"
        let ageRow = "details.row.age"
        let weightRow = "details.row.weight"
        let heightRow = "details.row.height"
        let hairColorRow = "details.row.hairColor"
        let professionsRow = "details.row.professions"
        let friendsRow = "details.row.friends"
        let friendsHeader = "details.friends.header"
        let friendsSection = "details.friends.section"
        let friend = "details.friend"
        let homeButton = "details.home.button"
    }
}

#Preview("Ready") {
    DetailsView(viewModel: DetailsViewModelPreview.ready)
}

#Preview("No friends") {
    DetailsView(viewModel: DetailsViewModelPreview.noFriends)
}

#Preview("Back Home") {
    DetailsView(showHome: true, viewModel: DetailsViewModelPreview.ready)
}
