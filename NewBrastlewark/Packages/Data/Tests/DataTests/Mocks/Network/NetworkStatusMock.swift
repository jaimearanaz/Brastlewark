import Foundation

@testable import Data

actor NetworkStatusMock: NetworkStatusProtocol {
    private var isInternetAvailableReturnValue = true

    func setInternetAvailable(_ isAvailable: Bool) {
        isInternetAvailableReturnValue = isAvailable
    }

    func isInternetAvailable() -> Bool {
        isInternetAvailableReturnValue
    }
}
