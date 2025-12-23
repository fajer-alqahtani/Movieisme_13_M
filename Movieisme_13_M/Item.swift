//
//  Item.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 03/07/1447 AH.
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
