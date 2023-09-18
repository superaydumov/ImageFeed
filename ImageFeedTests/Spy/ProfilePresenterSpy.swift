//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewController: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileIsCalled = false
    var cleanWebCookiesIsCalled = false
    var cleanServicesDataIsCalled = false
    var avatarURLIsCalled = false
    
    func avatarURL() -> URL? {
        avatarURLIsCalled = true
        return nil
    }
    
    func updateProfileDetails() -> [String]? {
        updateProfileIsCalled = true
        return nil
    }
    
    func cleanWebCookies() {
      cleanWebCookiesIsCalled = true
    }
    
    func cleanServicesData() {
        cleanServicesDataIsCalled = true
    }
    
    func logout() {
        cleanWebCookies()
        cleanServicesData()
    }
    
    
}
