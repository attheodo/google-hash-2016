//
//  helpers.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}


func distanceBetweenPoint(p1: Point, andPointB p2: Point) -> Int {
    
    let rowDelta = Int(pow(Double(p1.row - p2.row), Double(2)))
    let colDelta = Int(pow(Double(p1.column - p2.column), Double(2)))
    
    let sumSquared = sqrt(Double(rowDelta + colDelta))
    
    return Int(ceil(sumSquared))
    
}

func parseInputAtFilePath(filePath: String) -> [String] {
    
    let input = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
    let lines = input!.componentsSeparatedByString("\n")

    return lines
    
}

func parseSimulationParametersFromInputFile(lines: [String]) {
    
    let simulationParams = lines[0].componentsSeparatedByString(" ")
    
    mapRows = Int(simulationParams[0])!
    mapColumns = Int(simulationParams[1])!
    numOfDrones = Int(simulationParams[2])!
    deadlineTurns = Int(simulationParams[3])!
    maxDronePayload = Int(simulationParams[4])!
    
    print("📜: [\(mapRows), \(mapColumns)] - 🚁: \(numOfDrones) (Max Payload: \(maxDronePayload)kg) - ⏲: \(deadlineTurns) turns\n")
    
}

func parseProductTypesFromInputFile(lines: [String]) -> [Product] {
    
    var products:[Product] = []
    
    let numOfProductTypes = Int(lines[1])!
    
    let productTypes = lines[2].componentsSeparatedByString(" ")
    
    for (id, weight) in productTypes.enumerate() {
        
        let product = Product(id: id, weight: Int(weight)!)
        products.append(product)
    
    }
    
    assert(numOfProductTypes == products.count)
    print("📦 Parsed \(numOfProductTypes) products")
    
    return products

}

func parseWarehouseDataFromInputFile(lines: [String], andProductCatalog catalog:[Product]) -> [Warehouse] {
    
    var warehouses:[Warehouse] = []
    
    let numOfWarehouses = Int(lines[3])!
    
    var warehouseDataIndex = 4
    
    for i in 0..<numOfWarehouses {
        
        var inventory: [Product] = []
        
        let locationComponents = lines[warehouseDataIndex].componentsSeparatedByString(" ")
        let location = Point(row: Int(locationComponents[0])!, column: Int(locationComponents[1])!)

        let products = lines[warehouseDataIndex+1].componentsSeparatedByString(" ")
        
        for (productId, quantity) in products.enumerate() {
            
            let p = catalog.filter({ $0.id == Int(productId) })[0]
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
    
    return warehouses
    
}

func parseOrderDataFromInputFile(lines: [String], andProductCatalog catalog:[Product]) -> [Order] {
    
    var orders: [Order] = []

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
            
            let p = catalog.filter({ $0.id == Int(productId)! })[0]
            orderProducts.append(p)
       
        }
        
        let order = Order(id: i, location: location, products: orderProducts)
        
        assert(order.products.count == numOfProducts)
        
        orders.append(order)
        
        orderDataIndex += 3
        
    }
    
    assert(numOfOrders == orders.count)
    print("🚩 Parsed data for \(numOfOrders) orders\n")

    return orders
    
}


func getServiceClusterWithWarehouseId(id: Int, fromServiceClusters clusters:[ServiceCluster]) -> ServiceCluster? {
    
    let results = clusters.filter({ $0.warehouse.id == id })
    
    if results.count > 0 {
        return results[0]
    } else {
        return nil
    }
    
}

func getOrderWithId(id: Int, fromOrders orders:[Order]) -> Order {
    return orders.filter({ $0.id == id})[0]
}

func getWarehouseWithId(id: Int, fromWarehouses warehouses:[Warehouse]) -> Warehouse {
    return warehouses.filter({ $0.id == id})[0]
}

func getServiceClusterWithId(id: Int, fromServiceClusters serviceClusters:[ServiceCluster]) -> ServiceCluster {
    return serviceClusters.filter({ $0.id == id})[0]
}



func surplusProductQuantitiesInServiceCluster(cluster: ServiceCluster, forProducts products: [Product]) -> Int {
    
    var quantities = 0
    var stock = cluster.surplus
    
    for product in products {
       
        if stock.contains(product) {
            quantities += 1
            stock.removeObject(product)
        }
    
    }
    return quantities
    
}



