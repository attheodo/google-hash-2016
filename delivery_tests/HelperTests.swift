//
//  HelperTests.swift
//  delivery
//
//  Created by Athanasios Theodoridis on 13/02/16.
//  Copyright © 2016 Athanasios Theodoridis. All rights reserved.
//

import XCTest
import Nimble

@testable import delivery

class HelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testItProperlyCalculatesDistances() {
        
        var p1 = (row: 0, column: 10)
        var p2 = (row: 40, column: 24)
        
        expect(distanceBetweenPoint(p1, andPointB: p2)) == 43
        
        p1 = (row: 14, column: 66)
        p2 = (row: 76, column: 90)
        
        expect(distanceBetweenPoint(p1, andPointB: p2)) == 67

    }

    
}
