import SwiftUI

struct CharacterCell: View {
    let character: CharacterUIModel
    private let accessibilityIds = AccessibilytIdentifiers()
    private let constants = Constants()

    init(character: CharacterUIModel) {
        self.character = character
    }

    var body: some View {
        content
    }
}

// MARK: - Private methods

private extension CharacterCell {
    var content: some View {
        VStack {
            characterImage
            characterInfo
        }
    }

    var characterImage: some View {
        CachedAsyncImage(url: character.thumbnail) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: constants.imageSize, height: constants.imageSize)
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
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }

    var characterInfo: some View {
        VStack(spacing: 0) {
            Text(character.firstname)
                .font(.system(size: 16))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier(accessibilityIds.firstname)
            Text(character.surname)
                .font(.system(size: 13))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier(accessibilityIds.surname)
        }
        .frame(maxWidth: constants.imageSize)
    }

    func successImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: constants.imageSize, height: constants.imageSize)
            .clipped()
    }

    func fallbackImage() -> some View {
        Image(systemName: constants.neutralImage)
            .resizable()
            .scaledToFit()
            .frame(width: constants.imageSize, height: constants.imageSize)
            .foregroundColor(.gray)
    }
}

// MARK: - Constants

private extension CharacterCell {
    struct Constants {
        let imageSize: CGFloat = 100
        let neutralImage = "person.circle.fill"
    }

    struct AccessibilytIdentifiers {
        let loading = "charactercell.loading"
        let success = "charactercell.image.success"
        let failure = "charactercell.image.failure"
        let defaultImage = "charactercell.image.default"
        let firstname = "charactercell.firstname"
        let surname = "charactercell.surname"
    }
}

// MARK: - Previews

#Preview {
    CharacterCell(character: .init(
        id: 1,
        name: "Test Gnome",
        thumbnail: "https://example.com/image.jpg",
        age: 25,
        weight: 65.5,
        height: 120.0,
        hairColor: "Red",
        professions: ["Baker"],
        friends: ["Friend 1", "Friend 2"]
    ))
}
