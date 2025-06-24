import Foundation
import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).width
    }
}
