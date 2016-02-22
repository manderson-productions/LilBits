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

    func testGetPreviousTrackSucceedsWithTrack() {
        let e = self.expectationWithDescription("testGetPreviousTrackSucceedsWithTrack")
        DownloadQueue.sharedInstance.getNextTrack { track in
            XCTAssertNotNil(track)
            dispatch_async(dispatch_get_main_queue(), {
                DownloadQueue.sharedInstance.getPreviousTrack { track in
                    XCTAssertNotNil(track)
                    e.fulfill()
                }
            })
        }
        self.waitForExpectationsWithTimeout(120) { error in
            print("Error: \(error)")
        }
    }
}
