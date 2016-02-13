//
//  models.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

typealias Point = (row:Int, column:Int)

class Product: CustomStringConvertible, Equatable {
    
    var id: Int
    var weight: Int
    
    init(id: Int, weight: Int) {

        self.id = id
        self.weight = weight
    
    }
    
    var description:String {
        return "📦: 🏷\(id) (\(weight)kg)"
    }

}

func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && rhs.weight == lhs.weight
}

class Warehouse: CustomStringConvertible {
    
    var id: Int
    var location: Point
    var inventory: [Product]
    
    init(id: Int, location: Point, inventory: [Product]) {
        
        self.id = id
        self.location = location
        self.inventory = inventory
    }
    
    var description:String {
        return "🏢: 🏷\(id) - 📍[\(location.row),\(location.column)] - # 📦: \(inventory.count)"
    }
    
}

class Order: CustomStringConvertible {
    
    var id: Int
    var location: Point
    var products: [Product]
    
    init(id: Int, location: Point, products: [Product]) {
        
        self.id = id
        self.location = location
        self.products = products
    
    }
    
    var description: String {
        return "🚩: 🏷\(id) - 📍[\(location.row),\(location.column)] - # 📦 \(products.count)\n"
    }
    
}

class ServiceCluster: CustomStringConvertible {
    
    var id: Int
    var warehouse: Warehouse
    var orders: [Order]
    var surplus: [Product]
    var deficit: [Product]
    
    init(id: Int, warehouse: Warehouse, orders:[Order]) {
        
        self.id = id
        self.warehouse = warehouse
        self.orders = orders
        self.surplus = []
        self.deficit = []
    
    }
    
    var products: [Product] {
        return warehouse.inventory
    }
    
    var description: String {
        return "🌐: \(id) - 🏢: \(warehouse.id) - # 🚩 \(orders.count)"
    }
    
    func assignOrder(order: Order) {
        self.orders.append(order)
    }
    
    // finds surplus and deficit of products based on the orders assigned
    func calculateStock() {
        
        self.surplus.appendContentsOf(self.products)

        for order in orders {

            let orderDeliverables = order.products
            
            for deliverable in orderDeliverables {

                if surplus.contains(deliverable) {
                    surplus.removeObject(deliverable)
                } else {
                    deficit.append(deliverable)
                }
            
            }
            
        }
        
    }
    
    func printStock() {
        print("🌐: \(id) - 🚩: \(orders.count) - 📦 in 🏢 \(products.count)  - ✅📦: \(surplus.count) - ❌📦: \(deficit.count)")
    }
    
   
}