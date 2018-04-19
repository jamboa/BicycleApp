//
//  telecycleTests.swift
//  telecycleTests
//
//  Created by yoojonghyun on 2017. 12. 9..
//  Copyright © 2017년 yoojonghyun. All rights reserved.
//

import XCTest

@testable import telecycle

class StopWatchTests: XCTestCase, StopWatchDelgate {
    
    func doSomethingPeriodically(timeIntervalObject: TimeIntervalObject) {
        self.timeIntervalObject = timeIntervalObject
    }
    
    var timeIntervalObject: TimeIntervalObject!
    
    var stopWatch: StopWatch!
    
    override func setUp() {
        super.setUp()
        stopWatch = StopWatch(delegate: self, period: 1.0)
        stopWatch.start()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        stopWatch = nil
    }
    
    fileprivate func testIfGivenSecondsFlowsNormaly(_ numberOfSeconds: TimeInterval) {
        let givneSecondsHadToFlow = expectation(description: "givneSecondsHadToFlow")
        stopWatch.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + numberOfSeconds, execute: {
            var timeintervalObject = TimeIntervalObject(timeInterval: numberOfSeconds)
            timeintervalObject.fraction = 0
            self.timeIntervalObject.fraction = 0
            XCTAssertEqual(timeintervalObject, self.timeIntervalObject, "'durationInSeconds' is not set to correct value.")
            givneSecondsHadToFlow.fulfill()
        })
        waitForExpectations(timeout: numberOfSeconds + 1) { (error) in
            self.stopWatch.stop()
        }
    }
    
    func testIfOneSecondsFlowsNormaly() {
        testIfGivenSecondsFlowsNormaly(1)
    }
    
    func testIfTenSecondsFlowsNormaly() {
        testIfGivenSecondsFlowsNormaly(10)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
