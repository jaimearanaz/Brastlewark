import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
    
    var isValidNetworkURL: Bool {
        guard
            let url = URL(string: self),
            ["http", "https"].contains(url.scheme?.lowercased() ?? ""),
            url.host != nil
        else {
            return false
        }
        return true
    }
}
