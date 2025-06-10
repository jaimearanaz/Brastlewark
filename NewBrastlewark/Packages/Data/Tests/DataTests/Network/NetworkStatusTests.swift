import Testing
import SystemConfiguration
@testable import Data

// Mock for ReachabilityProviding
class MockReachabilityProvider: ReachabilityProviding {
    var createWithAddressResult: SCNetworkReachability? = UnsafeRawPointer(bitPattern: 0x1)?.assumingMemoryBound(to: SCNetworkReachability.self).pointee
    var getFlagsResult: Bool = true
    var flags: SCNetworkReachabilityFlags = []
    
    func createWithAddress(_ address: UnsafePointer<sockaddr>) -> SCNetworkReachability? {
        createWithAddressResult
    }
    func getFlags(_ target: SCNetworkReachability, _ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool {
        flags.pointee = self.flags
        return getFlagsResult
    }
}

struct NetworkStatusTests {
    @Test
    func given_reachableAndNoConnectionRequired_when_isInternetAvailable_then_returnsTrue() {
        let mock = MockReachabilityProvider()
        mock.flags = SCNetworkReachabilityFlags(rawValue: UInt32(kSCNetworkFlagsReachable))
        let sut = NetworkStatus(reachabilityProvider: mock)
        #expect(sut.isInternetAvailable() == true)
    }

    @Test
    func given_notReachable_when_isInternetAvailable_then_returnsFalse() {
        let mock = MockReachabilityProvider()
        mock.flags = []
        let sut = NetworkStatus(reachabilityProvider: mock)
        #expect(sut.isInternetAvailable() == false)
    }

    @Test
    func given_reachableButNeedsConnection_when_isInternetAvailable_then_returnsFalse() {
        let mock = MockReachabilityProvider()
        mock.flags = [SCNetworkReachabilityFlags(rawValue: UInt32(kSCNetworkFlagsReachable)), SCNetworkReachabilityFlags(rawValue: UInt32(kSCNetworkFlagsConnectionRequired))]
        let sut = NetworkStatus(reachabilityProvider: mock)
        #expect(sut.isInternetAvailable() == false)
    }

    @Test
    func given_flagsCannotBeRetrieved_when_isInternetAvailable_then_returnsFalse() {
        let mock = MockReachabilityProvider()
        mock.getFlagsResult = false
        let sut = NetworkStatus(reachabilityProvider: mock)
        #expect(sut.isInternetAvailable() == false)
    }
}
