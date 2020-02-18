//
//  iOSSwiftTableDisplayTests.swift
//  iOSSwiftTableDisplayTests
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import XCTest
@testable import iOSSwiftTableDisplay

let testURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
class iOSSwiftTableDisplayTests: XCTestCase {

    let hInteractor = HomeInteractor()
    var testURLIphone: String!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testURLIphone = testURL
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRequestURL() {
        let expectedURL = hInteractor.getAPIURL()
        XCTAssertEqual(expectedURL, testURLIphone, "URL should be match")
    }

    func testTableDataAPI() {

        // Create an expectation
        let expectation = self.expectation(description: "TableData API request is success and returns valid response")
        let expectedURL = hInteractor.getAPIURL()
        hInteractor.initiateTableDataAPIRequest(urlString: expectedURL, completionHandler: {(status, success, error) in
            XCTAssertTrue(status)
            XCTAssertNotNil(success, "TableData is nil")

            if error != nil {
                XCTAssertNil(error, "API Loading Error/ Invalid TableData")
            }
             expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

}
