//
//  logic.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

func serviceClustersBasedOnDistanceForWarehouses(warehouses: [Warehouse], andOrders orders: [Order]) -> [ServiceCluster] {
    
    var serviceClusters: [ServiceCluster] = []
    
    // 2D array, rows = warehouseIds, columns = orderIds
    var distanceMatrix = Array(count: warehouses.count, repeatedValue: Array(count: orders.count, repeatedValue: 0))
    
    // populate 2D array with all the distances between warehouses and orders
    for warehouse in warehouses {
        for order in orders {
            distanceMatrix[warehouse.id][order.id] = distanceBetweenPoint(warehouse.location, andPointB: order.location)
        }
    }
    
    for order in orders {
        
        var minDistance = distanceMatrix[0][0]
        var nearestWarehouseId = 0
        
        for warehouse in warehouses {
            if distanceMatrix[warehouse.id][order.id] < minDistance {
                minDistance = distanceMatrix[warehouse.id][order.id]
                nearestWarehouseId = warehouse.id
            }
        }
        
        // check if we already have a cluster servicing from this warehouse id
        let serviceCluster = getServiceClusterWithWarehouseId(nearestWarehouseId, fromServiceClusters: serviceClusters)
        
        
        // cool we have one, assign order to that
        if serviceCluster != nil {
        
            serviceCluster?.assignOrder(getOrderWithId(order.id, fromOrders: orders))
        
        }
        // cluster not found, let's create a new one
        else {
        
            let newServiceCluster = ServiceCluster(id: serviceClusters.count, warehouse: getWarehouseWithId(nearestWarehouseId, fromWarehouses: warehouses), orders: [getOrderWithId(order.id, fromOrders: orders)])
            serviceClusters.append(newServiceCluster)
        
        }
        
    }
    
    serviceClusters.sortInPlace({ $0.orders.count > $1.orders.count })
    
    print("✔︎ Created \(serviceClusters.count) 🌐 based on warehouse/orders distance.")
    
    return serviceClusters

}

func calculateStockForServiceClusters(clusters: [ServiceCluster]) {
    
    for cluster in clusters {
        cluster.calculateStock()
    }
    
}

func printServiceClusterStatsForClusters(clusters: [ServiceCluster]) {

    print("\n- Clusters Summary ----------------")

    for cluster in clusters {
        cluster.printStats()
    }
}

func supplyServiceClusters(clusters: [ServiceCluster]) {
    
    print("\n 🎉 Starting deficit supply coverage for 🌐s")
    
    for cluster in clusters {
        print("\t・ Supplying 🌐 \(cluster.id)")
        supplyServiceCluster(cluster, fromOtherServiceClusters: clusters)
    }
    
    print("\t✅ Supply complete")
}

func supplyServiceCluster(cluster: ServiceCluster, fromOtherServiceClusters clusters: [ServiceCluster]) {
    
    var supplierCandidateId = 0
    var maxDeficitCoverable = 0
    
    for c in clusters {
        
        if c.surplus.count > 0 {
            
            let surplusQuantities = surplusProductQuantitiesInServiceCluster(c, forProducts: cluster.deficit)

            if surplusQuantities > maxDeficitCoverable {
                supplierCandidateId = c.id
                maxDeficitCoverable = surplusQuantities
            }
        
        }
    }

    executeSupplyForCluster(cluster, fromSupplyingCluster: getServiceClusterWithId(supplierCandidateId, fromServiceClusters: clusters))
    
    if cluster.deficit.count > 0 {
        supplyServiceCluster(cluster, fromOtherServiceClusters: clusters)
    }
    
    cluster.status = .Supplied
    
}

func executeSupplyForCluster(cluster: ServiceCluster, fromSupplyingCluster supplyingCluster: ServiceCluster) {
    
    for product in cluster.deficit {

        if supplyingCluster.surplus.contains(product) {

            supplyingCluster.warehouse.inventory.removeObject(product)
            supplyingCluster.surplus.removeObject(product)
            cluster.warehouse.inventory.append(product)
            cluster.deficit.removeObject(product)

        }
    }
    
}

