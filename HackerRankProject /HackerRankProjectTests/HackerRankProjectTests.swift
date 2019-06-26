//
//  HackerRankProjectTests.swift
//  HackerRankProjectTests
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import XCTest
@testable import HackerRankProject

class HackerRankProjectTests: XCTestCase {
    
    var serviceLayer: ServiceLayer!
    var feature: Feature!
    var viewController: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        serviceLayer = ServiceLayer()
        feature = Feature()
        viewController = ViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        serviceLayer = nil
        feature = nil
        viewController = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testServiceRequest() {
        let expectation = self.expectation(description: "CountryInfo")
        var value: [String: Any]?
        
        serviceLayer.serviceRequestWithURL(url: URL_STRINGS.COUNTRY_FACTS) { (result) in
            if result.hasResult {
                value = result.value as? [String: Any]
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(((value?.count) != nil))
    }
    
    
    func testMockRequest() {
        let expectation = self.expectation(description: "CountryInfo")
        var value: [String: Any]?
        
        serviceLayer.mockRequestWithURL(url: URL_STRINGS.COUNTRY_FACTS) { (result) in
            if result.hasResult {
                value = result.value as? [String: Any]
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(((value?.count) != nil))
    }
    
    
    func testDataRequest() {
        serviceLayer.dataRequestWith(url: URL_STRINGS.COUNTRY_FACTS) { (result) in
            XCTAssert(self.serviceLayer.isMock)
        }
    }


}
