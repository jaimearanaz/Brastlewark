import Foundation

@testable import Data

class NetworkStatusMock: NetworkStatusProtocol {
    var isInternetAvailableReturnValue: Bool = true
    func isInternetAvailable() -> Bool {
        return isInternetAvailableReturnValue
    }
}
