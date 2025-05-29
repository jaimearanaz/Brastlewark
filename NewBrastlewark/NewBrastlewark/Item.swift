//
//  Item.swift
//  NewBrastlewark
//
//  Created by Jaime Aranaz on 29/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
