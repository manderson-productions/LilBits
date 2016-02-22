//
//  LilBitsTests.swift
//  LilBitsTests
//
//  Created by Mark Anderson on 2/19/16.
//  Copyright © 2016 markmakingmusic. All rights reserved.
//

import XCTest
@testable import LilBits

class LilBitsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private func setupExpectation() -> XCTestExpectation {
        let e = self.expectationWithDescription("asyncExpectation")
        self.waitForExpectationsWithTimeout(120) { error in
            print("Error: \(error)")
        }
        return e
    }

    private func fulfillExpectation(expectation: XCTestExpectation) {
        expectation.fulfill()
    }

    func testGetNextTrackSucceedsWithTrack() {
        let e = setupExpectation()
        DownloadQueue.sharedInstance.getNextTrack { [weak self] track in
            XCTAssertNotNil(track)
            self?.fulfillExpectation(e)
        }
    }

    func testGetPreviousTrackSucceedsWithTrack() {
        let e = setupExpectation()
        DownloadQueue.sharedInstance.getPreviousTrack { [weak self] track in
            XCTAssertNotNil(track)
            self?.fulfillExpectation(e)
        }
    }
}
