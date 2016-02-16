//
//  Helpers.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 15/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import Foundation

var startTime = NSDate()

func startTimer(){ startTime =  NSDate() }
func stopTimer(){
    print("\n⏱Completed in: \(-startTime.timeIntervalSinceNow) sec")
}

func distanceBetweenPoint(p1: Point, andPointB p2: Point) -> Int {
    
    let rowDelta = Int(pow(Double(p1.row - p2.row), Double(2)))
    let colDelta = Int(pow(Double(p1.column - p2.column), Double(2)))
    
    let sumSquared = sqrt(Double(rowDelta + colDelta))
    
    return Int(ceil(sumSquared))
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}