//
//  XCTestExampleTests.swift
//  XCTestExampleTests
//
//  Created by KAWASHIMA Yoshiyuki on 2021/08/19.
//

import XCTest
@testable import XCTestExample

class XCTestExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCounterPlus() throws {
        var counter = Counter()
        counter.plus()
        XCTAssertEqual(counter.count, 1)
    }
    
    func testCounterMinus() throws {
        var counter = Counter()
        counter.minus()
        XCTAssertEqual(counter.count, -1)
    }

    func testCounterSquare() throws {
        var counter = Counter()
        counter.minus()
        counter.square()
        XCTAssertEqual(counter.count, 1)
    }

    func testCounterReset() throws {
        var counter = Counter()
        counter.plus()
        counter.plus()
        counter.reset()
        XCTAssertEqual(counter.count, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
