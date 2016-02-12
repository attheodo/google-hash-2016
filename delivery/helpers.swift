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
