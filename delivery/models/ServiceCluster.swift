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
    var products: [Product]
    
    init(id: Int, warehouse: Warehouse, orders:[Order]) {
        
        self.id = id
        self.warehouse = warehouse
        self.orders = orders
        self.surplus = []
        self.deficit = []
        self.products = []
        self.products.appendContentsOf(self.warehouse.inventory)
        
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
        
        surplus.appendContentsOf(self.warehouse.inventory)
        
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
        
//        var quantity: [Product: Int] = [:]
//        
//        for p in deficit {
//            quantity[p] = (quantity[p] ?? 0) + 1
//        }
//        
//        let result = quantity.sort({ $0.1 > $1.1})
//        return (product: result[0].0, quantity: result[0].1)

        return (product: deficit[0], quantity: 1)
    }
    
    func removeFromInventory(product: Product, quantity: Int) {
        
        for _ in 0..<quantity {

            self.products.removeObject(product)
            
        }
        
    }
    
    func addToInventory(product: Product, quantity: Int) {
        
        for _ in 0..<quantity {
            
            self.products.append(product)
            
        }
                
    }
    
    func removeFromSurplus(product: Product, quantity: Int) {
        
        for _ in 0..<quantity {
            
            if self.surplus.contains(product) {
                self.surplus.removeObject(product)
            }
        }
    }
    
    func removeFromDeficit(product: Product, quantity: Int) {
        
        for _ in 0..<quantity {
            self.deficit.removeObject(product)
        }
    }
    


    
}