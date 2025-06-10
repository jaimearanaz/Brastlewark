import Foundation

enum NetworkErrors: Error, Equatable {
    case general
    case noNetwork
    case timeout
    case wrongUrl
    case statusError(Int)
    case wrongJson
}
