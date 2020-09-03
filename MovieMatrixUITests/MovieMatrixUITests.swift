//
//  MovieMatrixUITests.swift
//  MovieMatrixUITests
//
//  Created by pranay chander on 06/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import XCTest
@testable import MM_DEBUG

class MovieMatrixUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        XCTContext.runActivity(named: "Launch") { _ in
            app.launchArguments += ["UI-Testing"]
            app.launch()
            XCTAssertTrue(app.state == .runningForeground)
        }
        continueAfterFailure = false
    }
    
    override func tearDown() {
        app.terminate()
    }
}
