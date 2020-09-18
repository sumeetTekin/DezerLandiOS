//
//  LaunchTest.swift
//  Hotel LifeUITests
//
//  Created by Vikas Mehay on 04/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import XCTest

@testable import Hotel_Life

class LaunchTest: XCTestCase {
    var storyboard : UIStoryboard!
    var launchController : LaunchVC!
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        launchController = storyboard.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testFacebook() {
       // launchController.facebookBtn.tap()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
