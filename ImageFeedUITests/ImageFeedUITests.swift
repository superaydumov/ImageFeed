//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Эльдар Айдумов on 20.09.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private var app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authentificate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        sleep(5)
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        sleep(3)
        loginTextField.typeText("paste your email")
        sleep(3)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        sleep(3)
        XCUIApplication().toolbars.buttons["Done"].tap() // maintain the possible test fail because of keyboard lag
        passwordTextField.tap()
        passwordTextField.typeText("paste you password")
        sleep(3)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 7))
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        sleep(5)
        app.swipeUp()
        
        sleep(5)
        app.swipeDown()
        
        sleep(5)
        let tablesQuery = app.tables
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons.firstMatch.tap()
        sleep(5)
        cellToLike.buttons.firstMatch.tap()
        
        sleep(5)
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 60))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backNavigationButton = app.buttons["backButton"]
        backNavigationButton.tap()
        print(app.debugDescription)
    }
    
    func testProfile() {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
        XCTAssertTrue(app.staticTexts["paste your first and second name"].exists)
        XCTAssertTrue(app.staticTexts["paste your login"].exists)
        
        app.buttons["logoutButton"].tap()
        sleep(3)
        
        app.alerts["extendedAlert"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        
        XCTAssertTrue(app.buttons["Authentificate"].exists)
        print(app.debugDescription)
    }
}
