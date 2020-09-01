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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        XCTContext.runActivity(named: "Launch") { _ in
            
            app.launchArguments += ["UI-Testing"]
            app.launch()
            XCTAssertTrue(app.state == .runningForeground)
        }
            continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func testLogin() {
        XCTContext.runActivity(named: "Enter username") { _ in
            let usernameTextField = app.textFields["Username"]
            usernameTextField.tap()
            usernameTextField.typeText("pranaychander")
        }
        
        XCTContext.runActivity(named: "Enter password") { _ in
            let passwordSecureTextField = app.secureTextFields["Password"]
            passwordSecureTextField.tap()
            
        }
    }
    
    func testSearch() {
        
        XCTContext.runActivity(named: "Enter username") { _ in
            let usernameTextField = app.textFields["Username"]
            usernameTextField.tap()
            usernameTextField.typeText("pranaychander")
        }
        
        XCTContext.runActivity(named: "Enter password") { _ in
            let passwordSecureTextField = app.secureTextFields["Password"]
            passwordSecureTextField.tap()
            passwordSecureTextField.typeText("pratmdb")
        }
        
        XCTContext.runActivity(named: "Check Table") { _ in
            app.buttons["Login"].tap()
            app.tabBars["Tab Bar"].buttons["Search"].tap()
            app.searchFields["Enter Movie Name"].tap()
            app/*@START_MENU_TOKEN@*/.keys["A"]/*[[".keyboards.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            XCTAssertEqual(app.tables.cells.count, 20)
        }
        
        XCTContext.runActivity(named: "Scroll") { _ in
            app.tables.firstMatch.swipeUp(velocity: .fast)
        }
    }
    
}
