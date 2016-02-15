//
//  Order.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Order: CustomStringConvertible {
    
    var id: Int
    var location: Point
    var products: [Product]
    
    var description: String {
        return "🚩: 🏷\(id) - 📍[\(location.row),\(location.column)] - # 📦 \(products.count)\n"
    }
    
    init(id: Int, location: Point, products: [Product]) {
        
        self.id = id
        self.location = location
        self.products = products
        
    }
    
}