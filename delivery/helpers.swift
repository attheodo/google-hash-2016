//
//  helpers.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

typealias Point = (row:Int, column:Int)

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

func parseSimulationParametersFromInputFile(fileLines: [String]) {
    
    let simulationParams = fileLines[0].componentsSeparatedByString(" ")
    
    mapRows = Int(simulationParams[0])!
    mapColumns = Int(simulationParams[1])!
    numOfDrones = Int(simulationParams[2])!
    deadlineTurns = Int(simulationParams[3])!
    maxDronePayload = Int(simulationParams[4])!
    
    print("Map: [\(mapRows), \(mapColumns)] - Drones: \(numOfDrones) (Max Payload: \(maxDronePayload) units) - Deadline: \(deadlineTurns) turns\n")
    
}
