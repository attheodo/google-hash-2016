//
//  Drone.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Drone {

    var id: Int
    var maxPayload: Int
    var location: Point
    var inventory: [Product]
    var workload:Int
    var isAvailable:Bool {
        return workload == 0
    }
    
    init(id: Int, location: Point, maxPayload: Int, inventory: [Product]) {

        self.id = id
        self.location = location
        self.maxPayload = maxPayload
        self.inventory = inventory
        self.workload = 0
        
    }
    
    private func loadProduct(product: Product, quantity: Int) {
    
        var q = quantity
        
        while q != 0 {
            inventory.append(product)
            q -= 1
        }
        
        workload += 1
   
    }
    
    private func unloadProduct(product: Product, quantity: Int) {
        
        var q = quantity
        
        while q != 0 {
            inventory.removeObject(product)
            q -= 1
        }
        
        workload += 1
    }
    
    private func flyTo(location: Point) {
        workload += distanceBetweenPoint(self.location, andPointB: location)
        self.location = location
    }
    
    func moveProduct(product: Product, quantity: Int, fromCluster clusterA: ServiceCluster, toCluster clusterB: ServiceCluster) {
        
        flyTo(clusterA.warehouse.location)
        loadProduct(product, quantity: quantity)
        clusterA.removeFromInventory(product, quantity: quantity)
        // TODO: log actual command
        
        flyTo(clusterB.warehouse.location)
        unloadProduct(product, quantity: quantity)
        clusterB.addToInventory(product, quantity: quantity)
        // TODO: log actual command
        
        print("\n\t🚁\(id) moving (\(quantity) x 📦\(product.id)) (\(product.weight * quantity)kg) from 🌐\(clusterA.id) to 🌐\(clusterB.id) (⏱: \(workload))\n")

    }
    
    func deliverProduct(product: Product, quantity: Int, fromCluster cluster: ServiceCluster, forOrder order: Order) {
        
        flyTo(cluster.warehouse.location)
        loadProduct(product, quantity: quantity)
        cluster.removeFromInventory(product, quantity: quantity)
        // TODO: log actual command
        
        flyTo(order.location)
        unloadProduct(product, quantity: quantity)
        order.markDelivered(product, quantity: quantity)
        // TODO: log actuall command
        
        print("\n\t🚁\(id) delivering (\(quantity) x 📦\(product.id) (\(product.weight * quantity)kg) from 🌐\(cluster.id) to 🚩\(order.id) (⏱: \(workload))\n")
    
    }
    
    func executeWorkstep() {
        if workload > 0 {
            workload -= 1
        }
    }
    
    func maxLoadableQuantityForProduct(product: Product) -> Int {
        return Int(floor(Float(maxPayload/product.weight)))
    }
    
}