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

            Text(character.name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: imageSize)
        }
    }
}

#Preview {
    CharacterCell(character: .init(
        id: 1,
        name: "Test Gnome",
        thumbnail: "https://example.com/image.jpg",
        profession: "Baker",
        age: 25,
        weight: 65.5,
        height: 120.0,
        hairColor: "Red",
        friends: ["Friend 1", "Friend 2"]
    ))
}
