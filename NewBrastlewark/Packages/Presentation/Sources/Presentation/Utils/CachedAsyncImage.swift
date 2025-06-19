import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    private let url: String
    private let scale: CGFloat
    private let content: (AsyncImagePhase) -> Content
    @State private var cachedImage: UIImage?
    
    init(
        url: String,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.content = content
    }
    
    var body: some View {
        Group {
            if let cached = cachedImage {
                content(.success(Image(uiImage: cached)))
            } else {
                AsyncImage(
                    url: URL(string: url),
                    scale: scale
                ) { phase in
                    handlePhase(phase)
                }
            }
        }
        .onAppear {
            loadFromCache()
        }
    }
    
    @MainActor
    private func handlePhase(_ phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            saveToCache(image)
        }
        return content(phase)
    }
    
    private func loadFromCache() {
        Task {
            if let cached = await CachedImageManager.shared.get(url) {
                await MainActor.run {
                    self.cachedImage = cached
                }
            }
        }
    }
    
    private func saveToCache(_ image: Image) {
        guard cachedImage == nil else { return }
        
        Task {
            if let uiImage = await convertToUIImage(image) {
                await CachedImageManager.shared.add(uiImage, for: url)
                await MainActor.run {
                    self.cachedImage = uiImage
                }
            }
        }
    }
    
    private func convertToUIImage(_ image: Image) async -> UIImage? {
        let renderer = ImageRenderer(content: image)
        return renderer.uiImage
    }
}