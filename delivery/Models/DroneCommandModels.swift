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

class LoadCommand: DroneCommand, CustomStringConvertible {
    
    var warehouse: Warehouse
    var products: [Product]
    
    var cmdRepresentation: String {
        return "\(droneId) \(type.rawValue) \(warehouse.id) \(products[0].id) \(products.count)"
    }
    
    var description: String {
        return "🚁\(droneId) ⬅️ 🏢\(warehouse.id) (\(products.count)x📦\(products[0].id))"
    }
    
    init(droneId: Int, warehouse: Warehouse, productType: Product, productQuantity: Int) {
        
        self.warehouse = warehouse
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Load)
        
    }
    
}

class UnloadCommand: DroneCommand, CustomStringConvertible {
    
    var warehouse: Warehouse
    var products: [Product]
    
    var cmdRepresentation: String {
        return "\(droneId) \(type.rawValue) \(warehouse.id) \(products[0].id) \(products.count)"
    }
    
    var description: String {
        return "🚁\(droneId) ➡️ 🏢\(warehouse.id) (\(products.count)x📦\(products[0].id))"
    }

    init(droneId: Int, warehouse: Warehouse, productType: Product, productQuantity: Int) {
        
        self.warehouse = warehouse
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Unload)
        
    }
    
   
}

class DeliverCommand: DroneCommand, CustomStringConvertible {
    
    var order: Order
    var products: [Product]
    
    var cmdRepresentation: String {
        return "\(droneId) \(type.rawValue) \(order.id) \(products[0].id) \(products.count)"
    }
    
    var description: String {
        return "🚁\(droneId) ➡️ 🚩\(order.id) (\(products.count)x📦\(products[0].id))"
    }

    
    init(droneId: Int, order: Order, productType: Product, productQuantity: Int) {
        
        self.order = order
        self.products = []
        
        for _ in 0..<productQuantity {
            products.append(productType)
        }
        
        super.init(droneId: droneId, type: .Deliver)
        
    }
}

class WaitCommand: DroneCommand, CustomStringConvertible {
    
    var turns: Int
    
    var cmdRepresentation: String {
        return "\(droneId) \(type.rawValue) \(turns)"
    }
    
    var description: String {
        return "🚁\(droneId) ⏱ \(turns)"
    }

    
    init(droneId: Int, turns: Int) {
        
        self.turns = turns
        
        super.init(droneId: droneId, type: .Wait)
        
    }
}
