//
//  main.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

let inputFilePath = "/Users/thanosth/Documents/dev/google-hash-2016/specs/busy_day.in"

// Simulation Parameters
var mapRows: Int = 0
var mapColumns: Int = 0
var numOfDrones: Int = 0
var deadlineTurns: Int = 0
var maxDronePayload: Int = 0

// parse the text file into an array of lines
let inputFile = parseInputAtFilePath(inputFilePath)

// parse simulation parameters
parseSimulationParametersFromInputFile(inputFile)


