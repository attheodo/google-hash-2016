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
    var products: [Product]    
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

        for _ in 0..<quantity {
            self.products.removeObject(product)
        }
        
        if products.count == 0 {
            print("\t✅ 🚩\(id) fullfilled! 🎉")
            isFullfilled = true
        }

        
    }
        

    func mostWantedProduct() -> (product: Product, quantity: Int)? {
//        
//        var quantity: [Product: Int] = [:]
//        
//       
//        for p in self.products {
//            quantity[p] = (quantity[p] ?? 0) + 1
//        }
//        
//        let result = quantity.sort({ $0.1 > $1.1})
//        return (product: result[0].0, quantity: result[0].1)

        return (product: products[0], quantity: 1)
        
    }

    
}