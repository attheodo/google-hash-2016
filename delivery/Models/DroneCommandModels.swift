//
//  DroneCommands.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

enum DroneCommandType: String {
    case Load = "L"
    case Unload = "U"
    case Wait = "W"
    case Deliver = "D"
}


class DroneCommand {
    
    var droneId: Int
    var type:DroneCommandType
    
    init(droneId: Int, type: DroneCommandType) {
        self.droneId = droneId
        self.type = type
    }
}

class LoadCommand: DroneCommand {
    
    var warehouse: Warehouse
    var products: [Product]
    
    init(droneId: Int, warehouse: Warehouse, productType: Product, productQuantity: Int) {
        
        self.warehouse = warehouse
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Load)
        
    }
}

class UnloadCommand: DroneCommand {
    
    var warehouse: Warehouse
    var products: [Product]
    
    init(droneId: Int, warehouse: Warehouse, productType: Product, productQuantity: Int) {
        
        self.warehouse = warehouse
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Unload)
        
    }
}

class DeliverCommand: DroneCommand {
    
    var order: Order
    var products: [Product]
    
    init(droneId: Int, order: Order, productType: Product, productQuantity: Int) {
        
        self.order = order
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Deliver)
        
    }
}

class WaitCommand: DroneCommand {
    
    var turns: Int
    
    init(droneId: Int, turns: Int) {
        
        self.turns = turns
        
        super.init(droneId: droneId, type: .Wait)
        
    }
}
