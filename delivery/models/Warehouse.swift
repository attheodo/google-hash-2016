//
//  Warehouse.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

typealias Point = (row:Int, column:Int)

class Warehouse: CustomStringConvertible {
    
    var id: Int
    var location: Point
    var inventory: [Product]
    
    var description:String {
        return "🏢: 🏷\(id) - 📍[\(location.row),\(location.column)] - # 📦: \(inventory.count)"
    }
    
    init(id: Int, location: Point, inventory: [Product]) {
        
        self.id = id
        self.location = location
        self.inventory = inventory

    }

    
}
