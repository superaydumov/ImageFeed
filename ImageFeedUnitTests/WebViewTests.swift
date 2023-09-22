//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 15.09.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        controller.presenter = presenter
        presenter.view = controller
        
        //When
        _ = controller.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //Given
        let controller = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        controller.presenter = presenter
        presenter.view = controller
        
        //When
        presenter.webViewLoading()
        
        
        //Then
        XCTAssertTrue(controller.isLoadCalled)
    }
    
    func testProgressVisibleWhenLessThanOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.5
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //When
        let url = authHelper.authURL()
        let urlString = url?.absoluteString
        
        //Then
        XCTAssertTrue((urlString?.contains(configuration.accessKey)) != nil)
        XCTAssertTrue((urlString?.contains(configuration.secretKey)) != nil)
        XCTAssertTrue((urlString?.contains(configuration.redirectURI)) != nil)
        XCTAssertTrue((urlString?.contains(configuration.authURLString)) != nil)
        XCTAssertTrue((urlString?.contains("code")) != nil)
    }
    
    func testCodeFromURL() {
        //Given
        let authHelper = AuthHelper()
        
        let nativeURLString = "https://unsplash.com/oauth/authorize/native"
        var urlComponents = URLComponents(string: nativeURLString)
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents?.url
        guard let url else { return }
        
        //When
        let codeProperty = authHelper.code(from: url)
        
        //Then
        XCTAssertEqual(codeProperty, "test code")
    }
    
}
