//
//  ServiceClusterModel.swift
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
    var status: ServiceClusterStatus
    
    init(id: Int, warehouse: Warehouse, orders:[Order]) {
        
        self.id = id
        self.warehouse = warehouse
        self.orders = orders
        self.surplus = []
        self.deficit = []
        self.status = .AwaitingSupply
        
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
        print("🌐: \(id) - 🚩: \(orders.count) - 📦: \(products.count) - ✅📦: \(surplus.count) - ❌📦: \(deficit.count)")
    }

}
