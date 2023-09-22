//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testPresenterCallsSplash() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        //When
        presenter.logout()
        
        //Then
        XCTAssertTrue(viewController.splashIsCalled)
    }
    
    func testPresenterCallsUpdateProfile() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //When
        viewController.viewDidLoad()
        
        //Then
        XCTAssertTrue(presenter.updateProfileIsCalled)
    }
    
    func testOAuthTokenIsNil() {
        //Given
        let oauth2TokenStorage = OAuth2TokenStorage.shared
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter()
        viewController.configure(presenter)
        
        //When
        presenter.logout()
        
        //Then
        XCTAssertEqual(oauth2TokenStorage.token, nil)
    }
    
    func testPresenterCleansWebCookiesAndServicesData() {
        //Given
        let presenter = ProfilePresenterSpy()
        
        //When
        presenter.logout()
        
        //Then
        XCTAssertTrue(presenter.cleanWebCookiesIsCalled)
        XCTAssertTrue(presenter.cleanServicesDataIsCalled)
    }
    
    func testViewControllerCallsAvatarURL() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //When
        viewController.viewDidLoad()
        
        //Then
        XCTAssertTrue(presenter.avatarURLIsCalled)
    }
}
