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
        clusterA.warehouse.removeFromInventory(product, quantity: quantity)
        // TODO: log actual command
        
        flyTo(clusterB.warehouse.location)
        unloadProduct(product, quantity: quantity)
        clusterB.warehouse.addToInventory(product, quantity: quantity)
        // TODO: log actual command
        
        print("\t🚁\(id) moving (\(quantity) x 📦\(product.id)) from 🌐\(clusterA.id) to 🌐\(clusterB.id) (⏱: \(workload))")

    }
    
    func deliverProduct(product: Product, quantity: Int, fromCluster cluster: ServiceCluster, forOrder order: Order) {
        
        flyTo(cluster.warehouse.location)
        loadProduct(product, quantity: quantity)
        cluster.warehouse.removeFromInventory(product, quantity: quantity)
        // TODO: log actual command
        
        flyTo(order.location)
        unloadProduct(product, quantity: quantity)
        order.markDelivered(product, quantity: quantity)
        // TODO: log actuall command
        
        print("\t🚁\(id) delivering (\(quantity) x 📦\(product.id)) from 🌐\(cluster.id) to 🚩\(order.id) (⏱: \(workload))")
    
    }
    
}