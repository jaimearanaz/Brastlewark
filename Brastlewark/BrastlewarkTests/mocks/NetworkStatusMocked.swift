//
//  NetworkStatusMocked.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

@testable import Brastlewark

class NetworkStatusMocked: NetworkStatusProtocol {
    
    static var isInternetAvailableToReturn = true
    
    static func isInternetAvailable() -> Bool {
        return isInternetAvailableToReturn
    }
}
