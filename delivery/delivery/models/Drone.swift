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
    
    init(id: Int, location: Point, maxPayload: Int, inventory: [Product]) {

        self.id = id
        self.location = location
        self.maxPayload = maxPayload
        self.inventory = inventory
    
    }
    
}