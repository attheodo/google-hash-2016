//
//  Simulation.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Simulation {
    
    var deadline: Int
    
    var products:[Product]
    var orders:[Order]
    var warehouses:[Warehouse]
    var drones:[Drone]
    var clusters:[ServiceCluster]!
    
    init(products: [Product], orders: [Order], warehouses: [Warehouse], numOfDrones: Int, maxDronePayload: Int, deadline: Int) {
        
        self.deadline = deadline
        
        self.products = products
        self.orders = orders
        self.warehouses = warehouses
        self.drones = []
        
        // create our almighty army of drones
        for i in 0..<numOfDrones {

            let drone = Drone(id: i, location: self.warehouses[0].location, maxPayload: maxDronePayload, inventory: [])
            self.drones.append(drone)
            
        }
        
        print("📈 Starting simulation...")
    }
    
    func createServiceClusters() {
        
        clusters = []
        
        // 2D array, rows = warehouseIds, columns = orderIds
        var distanceMatrix = Array(count: warehouses.count, repeatedValue: Array(count: orders.count, repeatedValue: 0))
        
        // populate 2D array with all the distances between warehouses and orders
        for warehouse in warehouses {
            for order in orders {
                distanceMatrix[warehouse.id][order.id] = distanceBetweenPoint(warehouse.location, andPointB: order.location)
            }
        }
        
        for o in orders {
            
            let order = orders.filter({ $0.id == o.id })[0]
            
            var minDistance = distanceMatrix[0][0]
            var nearestWarehouseId = 0
            
            for warehouse in warehouses {
                if distanceMatrix[warehouse.id][order.id] < minDistance {
                    minDistance = distanceMatrix[warehouse.id][order.id]
                    nearestWarehouseId = warehouse.id
                }
            }
            
            // check if we already have a cluster servicing from this warehouse id
            let c = clusters.filter({ $0.warehouse.id == nearestWarehouseId })
            
            // cool we have one, assign order to that
            if c.count > 0 {
                c[0].assignOrder(order)
            }
            // cluster not found, let's create a new one
            else {
                
                let warehouse = warehouses.filter({ $0.id == nearestWarehouseId })[0]

                let newServiceCluster = ServiceCluster(id: clusters.count, warehouse: warehouse, orders: [order])
                clusters.append(newServiceCluster)
                
            }
            
        }
        
        clusters.sortInPlace({ $0.orders.count > $1.orders.count })
        calculateClustersStock()
        print("\t✔︎ Created \(clusters.count) 🌐 based on warehouse/orders distance.")
        
    }
    
    func printClusterStats() {
        
        print("\n\t・Clusters summary\n")
        
        for c in clusters {
            c.printStats()
        }
        
    }
    
    func calculateClustersStock() {
        
        for c in clusters {
            c.calculateStock()
        }
    }
    
}
