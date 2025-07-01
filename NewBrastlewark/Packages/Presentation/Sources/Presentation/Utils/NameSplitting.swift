import Foundation

public protocol NameSplitting {
    var name: String { get }
}

public extension NameSplitting {
    var firstname: String {
        let components = name.components(separatedBy: " ").filter { !$0.isEmpty }
        if let firstname = components.first {
            return firstname
        }
        return ""
    }
    
    var surname: String {
        let components = name.components(separatedBy: " ").filter { !$0.isEmpty }
        if components.count > 1 {
            return components.dropFirst().joined(separator: " ")
        }
        return ""
    }
}
