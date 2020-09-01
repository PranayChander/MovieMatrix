//
//  MovieMatrixTests.swift
//  MovieMatrixTests
//
//  Created by pranay chander on 06/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import XCTest
@testable import MM_DEBUG

class MovieMatrixTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGenerateRequestToken() {
        let expection = XCTestExpectation(description: "Request Token Recieved")
        MMNetworkClient.getRequestToken { (result, error) in
            XCTAssertEqual(result, true)
            expection.fulfill()
        }
//        wait(for: [expection], timeout: 2.0, enforceOrder: true)
        
        XCTWaiter(delegate: self).wait(for: [expection], timeout: 5, enforceOrder: true)
    }
    
    func testUserLogin() {
        let tokenExpection = XCTestExpectation(description: "Request Token Recieved")
        let loginExpection = XCTestExpectation(description: "Login Successful")
        MMNetworkClient.getRequestToken { (result, error) in
            XCTAssertEqual(result, true)
            tokenExpection.fulfill()
        }
        
        MMNetworkClient.userLogin(userName: "pranaychander", password: "pratmdb") { (result, error) in
            XCTAssertEqual(result, true)
            loginExpection.fulfill()
            
        }
        
        wait(for: [tokenExpection,loginExpection], timeout: 5.0, enforceOrder: true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
//        let exp1 = XCTestExpectation(description: "sa")
//        let exp2 = XCTestExpectation(description: "saw")
        let request = WatchlistNetworkRequest()
        let cont = MMPersistentStore.sharedInstance.privateManagedObjectContext
        let user = UserProfile(entity: UserProfile.entity(), insertInto: cont)
        do {
            try cont.save()
//            exp1.fulfill()
        } catch {
            XCTFail()
        }
        measure {
        MMAlamofireNetworkService.fetchLocalJSON(request) { (data) in
            if let json = data, let watchList = json["results"] as? [[String: Any]] {
//                exp2.fulfill()
               
                    UserMovie.saveUserMovies(movieJSON: watchList, user: user)
                }
            }
        }
//        wait(for: [exp1,exp2], timeout: 2.0, enforceOrder: true)
    }
}
