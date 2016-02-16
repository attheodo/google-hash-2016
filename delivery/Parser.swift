//
//  Parser.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Parser {
    
    // Simulation Parameters
    var rows: Int
    var cols: Int
    var numOfDrones: Int
    var deadline: Int
    var maxDronePayload: Int
    
    // Simulation Elements
    var products: [Product]!
    var warehouses: [Warehouse]!
    var orders: [Order]!
    
    init(filePath: String) {
        
        let file = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        let fileLines = file!.componentsSeparatedByString("\n")

        let simulationParams = fileLines[0].componentsSeparatedByString(" ")
        
        self.rows = Int(simulationParams[0])!
        self.cols = Int(simulationParams[1])!
        self.numOfDrones = Int(simulationParams[2])!
        self.deadline = Int(simulationParams[3])!
        self.maxDronePayload = Int(simulationParams[4])!
        
        print("📜: [\(rows), \(cols)] - 🚁: \(numOfDrones) (Max Payload: \(maxDronePayload)kg) - ⏲: \(deadline) turns\n")
        
        parseProductTypesFromLines(fileLines)
        parseWarehousesFromLines(fileLines)
        parseOrdersFromLines(fileLines)

    }
    
    func parseProductTypesFromLines(lines: [String]) {
        
        products = []
        
        let numOfProductTypes = Int(lines[1])!
        let productTypes = lines[2].componentsSeparatedByString(" ")
        
        for (id, weight) in productTypes.enumerate() {
            
            let product = Product(id: id, weight: Int(weight)!)
            products.append(product)
            
        }
        
        assert(numOfProductTypes == products.count)
        print("📦 Parsed \(numOfProductTypes) products")
    
    }
    
    func parseWarehousesFromLines(lines: [String]) {
        
        warehouses = []
        
        let numOfWarehouses = Int(lines[3])!
        var warehouseDataIndex = 4
        
        for i in 0..<numOfWarehouses {
            
            var inventory: [Product] = []
            
            let locationComponents = lines[warehouseDataIndex].componentsSeparatedByString(" ")
            let location = Point(row: Int(locationComponents[0])!, column: Int(locationComponents[1])!)
            
            let warehouseInventory = lines[warehouseDataIndex+1].componentsSeparatedByString(" ")
            
            for (productId, quantity) in warehouseInventory.enumerate() {
                
                let p = products.filter({ $0.id == Int(productId) })[0]
                var q = Int(quantity)!
                while(q != 0) {
                    inventory.append(p)
                    q -= 1
                }
                
            }
            
            let warehouse = Warehouse(id: i, location: location, inventory: inventory)
            
            warehouses.append(warehouse)
            
            warehouseDataIndex += 2
            
        }
        
        assert(numOfWarehouses == warehouses.count)
        print("🏢 Parsed data for \(numOfWarehouses) warehouses")
    
    }
    
    func parseOrdersFromLines(lines: [String]) {
        
        orders = []
        
        let numOfWarehouses = Int(lines[3])!
        var orderDataIndex = 4 + numOfWarehouses * 2
        
        let numOfOrders = Int(lines[orderDataIndex])!
        
        for i in 0..<numOfOrders {
            
            var orderProducts: [Product] = []
            
            let locationComponents = lines[orderDataIndex+1].componentsSeparatedByString(" ")
            let location = Point(row: Int(locationComponents[0])!, column: Int(locationComponents[1])!)
            
            let numOfProducts = Int(lines[orderDataIndex+2])!
            
            let products = lines[orderDataIndex+3].componentsSeparatedByString(" ")
            
            for productId in products {
                
                let p = self.products.filter({ $0.id == Int(productId)! })[0]
                orderProducts.append(p)
                
            }
            
            let order = Order(id: i, location: location, products: orderProducts)
            
            assert(order.products.count == numOfProducts)
            
            orders.append(order)
            
            orderDataIndex += 3
            
        }
        
        assert(numOfOrders == orders.count)
        print("🚩 Parsed data for \(numOfOrders) orders\n")
    }

}