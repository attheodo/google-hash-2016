//
//  Parser.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

class Parser {
    
    var rows: Int
    var cols: Int
    var numOfDrones: Int
    var deadline: Int
    var maxDronePayload: Int
    
    init(filePath: String) {
        
        let file = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        let fileLines = file!.componentsSeparatedByString("\n")

        
        let simulationParams = fileLines[0].componentsSeparatedByString(" ")
        
        self.rows = Int(simulationParams[0])!
        self.cols = Int(simulationParams[1])!
        self.numOfDrones = Int(simulationParams[2])!
        self.deadline = Int(simulationParams[3])!
        self.maxDronePayload = Int(simulationParams[4])!
        
        print("📜: [\(rows), \(cols)] - 🚁: \(numOfDrones) (Max Payload: \(maxDronePayload)kg) - ⏲: \(deadline) turns\n")

    }
}