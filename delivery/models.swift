//
//  models.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

struct Product: CustomStringConvertible {
    
    var id: Int
    var weight: Int
    
    init(id: Int, weight: Int) {

        self.id = id
        self.weight = weight
    
    }
    
    var description:String {
        return "ProductId: \(id) (\(weight)kg)\n"
    }

}