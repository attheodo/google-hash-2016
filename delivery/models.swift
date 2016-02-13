//
//  models.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

typealias Point = (row:Int, column:Int)

struct Product: CustomStringConvertible {
    
    var id: Int
    var weight: Int
    
    init(id: Int, weight: Int) {

        self.id = id
        self.weight = weight
    
    }
    
    var description:String {
        return "ProductId: \(id) (\(weight)kg)"
    }

}

struct Warehouse: CustomStringConvertible {
    
    var id: Int
    var location: Point
    var inventory: [Product]
    
    init(id: Int, location: Point, inventory: [Product]) {
        
        self.id = id
        self.location = location
        self.inventory = inventory
    }
    
    var description:String {
        return "WarehouseId: \(id) - Location: [\(location.row),\(location.column)] - # Products: \(inventory.count)"
    }
    
}

struct Order: CustomStringConvertible {
    
    var id: Int
    var deliveryLocation: Point
    var products: [Product]
    
    init(id: Int, deliveryLocation location: Point, products: [Product]) {
        
        self.id = id
        self.deliveryLocation = location
        self.products = products
    
    }
    
    var description: String {
        return "OrderId: \(id) - Delivery to: [\(deliveryLocation.row),\(deliveryLocation.column)] - # Products \(products.count)"
    }
    
}