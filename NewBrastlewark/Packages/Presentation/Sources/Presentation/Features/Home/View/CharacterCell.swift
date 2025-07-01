import SwiftUI

struct CharacterCell: View {
    let character: CharacterUIModel
    private let imageSize: CGFloat = 100

    init(character: CharacterUIModel) {
        self.character = character
    }

    var body: some View {
        VStack {
            CachedAsyncImage(url: character.thumbnail) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                @unknown default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                }
            }
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )

            VStack(spacing: 0) {
                Text(character.firstname)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Text(character.surname)
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: imageSize)
        }
    }
}

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
