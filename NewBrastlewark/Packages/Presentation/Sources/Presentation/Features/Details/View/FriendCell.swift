import SwiftUI

struct FriendCell: View {
    let friend: DetailsFriendUIModel
    private let constants = Constants()
    private let accessibilityIds = AccessibilityIdentifiers()

    var body: some View {
        content
    }
}

// MARK: - Private methods

private extension FriendCell {
    var content: some View {
        VStack {
            imageView
            infoView
        }
        .frame(width: constants.cellWidth, height: constants.cellHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(friend.name)
        .accessibilityIdentifier("\(accessibilityIds.friendCell).\(friend.id)")
    }

    var imageView: some View {
        ZStack {
            if let url = URL(string: friend.thumbnail), !friend.thumbnail.isEmpty {
                asyncImageView(url: url)
            } else {
                fallbackImage()
                    .accessibilityIdentifier(accessibilityIds.defaultImage)
            }
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        }
        .frame(width: constants.imageSize, height: constants.imageSize)
    }

    func asyncImageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .accessibilityIdentifier(accessibilityIds.loading)
            case .success(let image):
                successImage(image)
                    .accessibilityIdentifier(accessibilityIds.success)
            case .failure:
                fallbackImage()
                    .accessibilityIdentifier(accessibilityIds.failure)
            @unknown default:
                fallbackImage()
                    .accessibilityIdentifier(accessibilityIds.defaultImage)
            }
        }
    }

    func successImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
    }

    func fallbackImage() -> some View {
        Image(systemName: constants.personIcon)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(.gray)
    }

    var infoView: some View {
        VStack(spacing: 0) {
            Text(friend.firstname)
                .font(.system(size: 16))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier(accessibilityIds.firstname)

            Text(friend.surname)
                .font(.system(size: 13))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier(accessibilityIds.surname)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Constants

private extension FriendCell {
    struct Constants {
        let imageSize: CGFloat = 60
        let cellWidth: CGFloat = 80
        let cellHeight: CGFloat = 100
        let personIcon = "person.circle.fill"
    }

    struct AccessibilityIdentifiers {
        let friendCell = "friend.cell"
        let loading = "friendcell.loading"
        let success = "friendcell.image.success"
        let failure = "friendcell.image.failure"
        let defaultImage = "friendcell.image.default"
        let firstname = "friendcell.firstname"
        let surname = "friendcell.surname"
    }
}

// MARK: - Previews

#Preview {
    FriendCell(friend: .init(
        id: 1,
        name: "Test Friend",
        thumbnail: "https://example.com/image.jpg"
    ))
}
