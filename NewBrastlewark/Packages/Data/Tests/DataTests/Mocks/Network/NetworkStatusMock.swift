import Foundation

@testable import Data

class NetworkStatusMock: NetworkStatusProtocol {
    var isInternetAvailableReturnValue = true
    func isInternetAvailable() -> Bool {
        return isInternetAvailableReturnValue
    }
}
