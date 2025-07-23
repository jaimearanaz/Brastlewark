import SwiftUI

actor CachedImageManager {
    static let shared = CachedImageManager()
    
    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    private init() {}
    
    func add(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(_ key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
