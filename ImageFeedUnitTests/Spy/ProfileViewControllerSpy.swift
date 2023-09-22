//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var splashIsCalled = false
    
    func switchToSplashViewController() {
        splashIsCalled = true
    }
}
