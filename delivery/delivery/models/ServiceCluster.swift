//
//  ServiceCluster.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

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
        
        surplus.removeAll()
        deficit.removeAll()
        
        surplus.appendContentsOf(self.products)
        
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
    
    func printStats() {
        print("\t\t🌐: \(id) - 🚩: \(orders.count - orders.filter({ $0.isFullfilled == true}).count) - 📦: \(products.count) - ✅📦: \(surplus.count) - ❌📦: \(deficit.count)")
    }
    
    func mostWantedProduct() -> (product: Product, quantity: Int) {
        
        var quantity: [Product: Int] = [:]
        
        for p in deficit {
            quantity[p] = (quantity[p] ?? 0) + 1
        }
        
        let result = quantity.sort({ $0.1 > $1.1})
        return (product: result[0].0, quantity: result[0].1)
        
    }
    
    func removeFromInventory(product: Product, quantity: Int) {
        
        var q = quantity
        
        while q != 0 {
            warehouse.inventory.removeObject(product)
            if surplus.contains(product) {
                surplus.removeObject(product)
            }
            q -= 1
        }
    }
    
    func addToInventory(product: Product, quantity: Int) {
        
        var q = quantity
        
        while q != 0 {
            warehouse.inventory.append(product)
            if deficit.contains(product) {
                deficit.removeObject(product)
            }
            q -= 1
        }
    }


    
}