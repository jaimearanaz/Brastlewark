import SwiftUI

struct CharacterCell: View {
    let character: CharacterUIModel

    init(character: CharacterUIModel) {
        self.character = character
    }

    var body: some View {
        VStack {
            if let thumbnail = character.thumbnail {
                AsyncImage(url: URL(string: thumbnail)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }

            Text(character.name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
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