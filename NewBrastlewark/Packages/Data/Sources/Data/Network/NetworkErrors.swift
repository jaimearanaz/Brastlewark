import Foundation

enum NetworkErrors: Error {
    case general
    case noNetwork
    case timeout
    case wrongUrl
    case statusError(Int)
    case wrongJson
}
