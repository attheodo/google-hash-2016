//
//  main.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

//let inputFilePath = "/Users/thanosth/Documents/dev/google-hash-2016/specs/busy_day.in"
//let inputFilePath = "/Users/thanosth/Documents/dev/google-hash-2016/specs/mother_of_all_warehouses.in"
//let inputFilePath = "/Users/thanosth/Documents/dev/google-hash-2016/specs/simple.in"
let inputFilePath = "/Users/thanosth/Documents/dev/google-hash-2016/specs/redundancy.in"

startTimer()

let parser = Parser(filePath: inputFilePath)

let simulation = Simulation(products: parser.products, orders: parser.orders, warehouses: parser.warehouses, numOfDrones: parser.numOfDrones, maxDronePayload: parser.maxDronePayload, deadline: parser.deadline, percentageOfDeliveryDrones: 70)

simulation.createServiceClusters()
simulation.printClusterStats()
simulation.startSimulation()

stopTimer()