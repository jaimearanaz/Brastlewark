import SwiftUI

struct FriendCell: View {
    let friend: DetailsFriendUIModel

    var body: some View {
        VStack {
            ZStack {
                if let url = URL(string: friend.thumbnail), !friend.thumbnail.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
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
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.gray)
                }
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            }
            .frame(width: 60, height: 60)

            VStack(spacing: 0) {
                Text(friend.firstname)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                Text(friend.surname)
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 80, height: 100)
    }
}
