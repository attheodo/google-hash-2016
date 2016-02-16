//
//  Product.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Product: CustomStringConvertible, Equatable, Hashable {
    
    var id: Int
    var weight: Int
    
    var description:String {
        return "📦: 🏷\(id) (\(weight)kg)"
    }
    
    var hashValue: Int {
        return id.hashValue
    }

    init(id: Int, weight: Int) {
        
        self.id = id
        self.weight = weight
        
    }
    
    
}

func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && rhs.weight == lhs.weight
}
