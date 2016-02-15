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
    var isFullfilled: Bool
    var products: [Product] {
        didSet {
            if products.count == 0 {
                print("\t🚩\(id) fullfilled! 🎉")
                isFullfilled = true
            }
        }
    }
    
    var description: String {
        return "🚩: 🏷\(id) - 📍[\(location.row),\(location.column)] - # 📦 \(products.count)\n"
    }
    
    init(id: Int, location: Point, products: [Product]) {
        
        self.id = id
        self.location = location
        self.products = products
        self.isFullfilled = false
        
    }
    
    func markDelivered(product: Product, quantity: Int) {

        var q = quantity
        
        while q != 0 {
            products.removeObject(product)
            q -= 1
        }
    }
        
    func mostWantedProduct() -> Product {
        
        var quantity: [Product: Int] = [:]
        
        for p in products {
            quantity[p] = (quantity[p] ?? 0) + 1
        }
        
        let result = quantity.sort({ $0.1 > $1.1})
        return result[0].0
        
    }
    
}