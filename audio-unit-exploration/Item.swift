//
//  Item.swift
//  audio-unit-exploration
//
//  Created by Connor on 8/7/26.
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
