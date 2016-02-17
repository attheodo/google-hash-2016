//
//  Drone.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Drone: CustomStringConvertible, Equatable  {

    var id: Int
    var maxPayload: Int
    var location: Point
    var inventory: [Product]
    var workload:Int
    var isAvailable:Bool {
        return workload == 0 && totalWorkload <= simulation.deadline
    }
    var hasReachedDeadline: Bool = false
    
    var totalWorkload: Int = 0
    
    var description:String {
        return "🚁\(id) [\(location.row),\(location.column) W: \(workload)]\n"
    }
    
    init(id: Int, location: Point, maxPayload: Int, inventory: [Product]) {

        self.id = id
        self.location = location
        self.maxPayload = maxPayload
        self.inventory = inventory
        self.workload = 0
        
    }
    
    private func loadProduct(product: Product, quantity: Int) {
    
        
        for _ in 0..<quantity {
            self.inventory.append(product)
        }
               
        workload += 1
   
    }
    
    private func unloadProduct(product: Product, quantity: Int) {
        
        for _ in 0..<quantity {
            self.inventory.removeObject(product)
        }
        
        workload += 1
    }
    
    private func wait(turns: Int) {
        
        for _ in 0..<turns {
            workload += 1
        }
    }
    
    private func flyTo(remoteLocation: Point) {
        workload += distanceBetweenPoint(self.location, andPointB: remoteLocation)
        self.location = remoteLocation
    }
    
    func moveProduct(product: Product, quantity: Int, fromCluster clusterA: ServiceCluster, toCluster clusterB: ServiceCluster) {
        
        flyTo(clusterA.warehouse.location)
        loadProduct(product, quantity: quantity)
        flyTo(clusterB.warehouse.location)
        unloadProduct(product, quantity: quantity)
        
        if workload  > simulation.deadline - totalWorkload {
            return
        }
        
        // perform cluster inventory operations
        clusterA.removeFromInventory(product, quantity: quantity)
        clusterA.removeFromSurplus(product, quantity: quantity)
        clusterB.addToInventory(product, quantity: quantity)
        clusterB.removeFromDeficit(product, quantity: quantity)
        
        // log commands
        simulation.logLoadCommand(self, warehouse: clusterA.warehouse, product: product, quantity: quantity)
        simulation.logUnloadCommand(self, warehouse: clusterB.warehouse, product: product, quantity: quantity)
            
        let p = ProductLocation(productId: product.id, warehouseId: clusterB.warehouse.id)
        simulation.productLeadTimes[p] = self.workload
        
        print("\n\t🚁\(id) moving (\(quantity) x 📦\(product.id)) (\(product.weight * quantity)kg) from 🌐\(clusterA.id) to 🌐\(clusterB.id) (⏱: \(workload))\n")

        
    }
    
    func deliverProduct(product: Product, quantity: Int, fromCluster cluster: ServiceCluster, forOrder order: Order) {
       
        let p = ProductLocation(productId: product.id, warehouseId: cluster.warehouse.id)
        
        if simulation.productLeadTimes[p] != nil {
            
            let waitTurns = simulation.productLeadTimes[p]!
            
            wait(waitTurns)
            
            if workload > simulation.deadline - totalWorkload {
                return
            }
            simulation.logWaitCommand(self, turns: waitTurns)
            
            print("\n\t🚁\(id) will wait \(waitTurns) before trying to deliver 📦\(product.id) from 🌐\(cluster.id)")
            
            simulation.productLeadTimes[p] = nil
            
            return
            
        }
        
        flyTo(cluster.warehouse.location)
        loadProduct(product, quantity: quantity)
        flyTo(order.location)
        unloadProduct(product, quantity: quantity)
        
        if workload > simulation.deadline - totalWorkload {
            return
        }
        
        // perform inventoru operations
        cluster.removeFromInventory(product, quantity: quantity)
        order.markDelivered(product, quantity: quantity)

        simulation.logLoadCommand(self, warehouse: cluster.warehouse, product: product, quantity: quantity)
        simulation.logDeliverCommand(self, order: order, product: product, quantity: quantity)
        
        print("\n\t🚁\(id) delivering (\(quantity) x 📦\(product.id) (\(product.weight * quantity)kg) from 🌐\(cluster.id) to 🚩\(order.id) (⏱: \(workload))\n")

        
        
    }
    
    func executeWorkstep() {

       
        if workload > 0 {
            
            workload -= 1
            
            totalWorkload += 1
            
            if totalWorkload == simulation.deadline {
                hasReachedDeadline = true
                return
            }
            
        }
    }
    
    func maxLoadableQuantityForProduct(product: Product) -> Int {
        return maxPayload/product.weight
    }
    
}
func ==(lhs: Drone, rhs:Drone) -> Bool {
    return lhs.id == rhs.id
}
