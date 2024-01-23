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
        count += 2
    }
    
    mutating func minus() {
        count -= 2
    }
    
    mutating func reset() {
        count = 0
    }
}
