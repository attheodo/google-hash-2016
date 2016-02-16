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
    var currentTurn: Int
    var isFinished: Bool
    
    var products:[Product]
    var orders:[Order]
    var warehouses:[Warehouse]
    var deliveryDrones:[Drone]
    var supplyDrones:[Drone]
    var clusters:[ServiceCluster]!
    
    init(products: [Product], orders: [Order], warehouses: [Warehouse], numOfDrones: Int, maxDronePayload: Int, deadline: Int, percentageOfDeliveryDrones: Int) {
        
        self.deadline = deadline
        self.currentTurn = 0
        self.isFinished = false
        
        self.products = products
        self.orders = orders
        self.warehouses = warehouses
        self.deliveryDrones = []
        self.supplyDrones = []
        
        let numOfDeliveryDrones = floor(Float(numOfDrones) * (Float(percentageOfDeliveryDrones)/100))

        // create our almighty army of drones
        for i in 0..<numOfDrones {
            
            let drone = Drone(id: i, location: self.warehouses[0].location, maxPayload: maxDronePayload, inventory: [])
            
            if deliveryDrones.count != Int(numOfDeliveryDrones) {
                self.deliveryDrones.append(drone)
            } else {
                self.supplyDrones.append(drone)
            }
            
        }
        
        print("📈 Starting simulation with \(deliveryDrones.count) delivery 🚁 and \(supplyDrones.count) supply 🚁")
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
    
    func startSimulation() {
        
        while currentTurn < deadline  && !isFinished {
            currentTurn += 1
            executeTurn()
        }
        
        printClusterStats()
    }
    
    func executeTurn() {
        print("⏱ Turn: \(currentTurn)")
        
        for c in clusters {
            
            let unfullfilledOrders = c.orders.filter({ $0.isFullfilled == false })
            
            if unfullfilledOrders.count == 0 {
                isFinished = true
                return
            }
            
            // for each unfullfilled order
            for o in unfullfilledOrders {

                if c.deficit.count > 0 {
                    partiallyCoverDeficitForCluster(c)
                }
                
               deliverProductsForOrder(o, fromCluster: c)
                
            }
            
            // merge all kind of drones and have them execute
            for drone in supplyDrones {
                drone.executeWorkstep()
            }
            
            for drone in deliveryDrones {
                drone.executeWorkstep()
            }
        }
        
    }
    
    func deliverProductsForOrder(order: Order, fromCluster cluster: ServiceCluster) {
        //print("\t・Delivering products for 🚩\(order.id) from 🌐\(cluster.id)")
        if let drone = findAvailableDroneOfType("Deliver", nearCluster: cluster) {
          //  print("\t\t→ Found available delivery drone 🚁\(drone.id)")
            let mostWantedProduct = order.mostWantedProduct()
           
            if cluster.products.filter({ $0 == mostWantedProduct.product}).count >= mostWantedProduct.quantity {
                let quantity = min(mostWantedProduct.quantity, drone.maxLoadableQuantityForProduct(mostWantedProduct.product))
                drone.deliverProduct(mostWantedProduct.product, quantity: quantity, fromCluster: cluster, forOrder: order)
            } else {
                // TODO: make drone wait a bit
            }
            
        } else {
            //print("\t\t❌ No available delivery drone nearby")
            return
        }
    }
    
    func partiallyCoverDeficitForCluster(cluster: ServiceCluster) {
        
        //print("\t・Partially covering deficit for 🌐\(cluster.id)")
        let mostWantedProduct = cluster.mostWantedProduct()
        let nearestCluster = findNearestClusterWithProduct(mostWantedProduct.product, andQuantity: mostWantedProduct.quantity)
        //print("\t\t→ Nearest 🌐 with \(mostWantedProduct.quantity) x 📦\(mostWantedProduct.product.id) is 🌐\(nearestCluster.id)")
        
        if let drone = findAvailableDroneOfType("supply", nearCluster: nearestCluster) {
        
            //print("\t\t→ Found available supply drone 🚁\(drone.id)")
            let quantity = min(mostWantedProduct.quantity, drone.maxLoadableQuantityForProduct(mostWantedProduct.product))
            drone.moveProduct(mostWantedProduct.product, quantity: quantity, fromCluster: nearestCluster, toCluster: cluster)
        
        } else {
            //print("\t\t❌ No available supply drone nearby")
            return
        }

        
    }
    
    func findNearestClusterWithProduct(product: Product, andQuantity quantity:Int) -> ServiceCluster {
        let clusters = self.clusters.filter({ $0.surplus.filter({ $0.id == product.id}).count >= quantity })
        // TODO: also filter by distance
        return clusters[0]
    }
    
    func findAvailableDroneOfType(type:String, nearCluster cluster: ServiceCluster) -> Drone? {
        
        let availableDrones:[Drone]?
        
        if type == "supply" {
            availableDrones = supplyDrones.filter({ $0.isAvailable == true })
        } else {
            availableDrones = deliveryDrones.filter({ $0.isAvailable == true })
        }
        
        guard let drones = availableDrones where drones.count > 0 else {
            return nil
        }
        
        var nearestDrone = drones[0]
        var minDistance = distanceBetweenPoint(cluster.warehouse.location, andPointB: nearestDrone.location)
        
        for drone in drones {
            
            let distance = distanceBetweenPoint(cluster.warehouse.location, andPointB: drone.location)
            if distance < minDistance {
                minDistance = distance
                nearestDrone = drone
            }
        }
        
        return nearestDrone
            
       
    }
    
}
