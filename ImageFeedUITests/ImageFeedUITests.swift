//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Эльдар Айдумов on 19.09.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testAuth() throws {
        app.buttons["Authentificate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 7))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("email")
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("password")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 7))
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        firstCell.swipeUp()

        sleep(3)
        let secondCell = tablesQuery.children(matching: .cell).element(boundBy: 2)
        secondCell.buttons["likeButton"].tap()

        sleep(5)
        secondCell.buttons["likeButton"].tap()

        sleep(5)
        secondCell.tap()

        sleep(3)
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let backNavigationButton = app.buttons["backButton"]
        backNavigationButton.tap()
    }
    
    func testProfile() {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
        XCTAssertTrue(app.staticTexts["name"].exists)
        XCTAssertTrue(app.staticTexts["login"].exists)
        
        app.buttons["logoutButton"].tap()
        sleep(3)
        
        app.alerts["extendedAlert"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        
        XCTAssertTrue(app.buttons["Authentificate"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
