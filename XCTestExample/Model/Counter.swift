//
//  Counter.swift
//  XCTestExample
//
//  Created by KAWASHIMA Yoshiyuki on 2021/08/19.
//

import Foundation

struct Counter {
    var count: Int = 0
    
    mutating func plus() {
        count += 1
    }
    
    mutating func minus() {
        count -= 1
    }
    
    mutating func square() {
        count *= count
    }

    mutating func reset() {
        count = 0
    }
}
