//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation
import WebKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    
    weak var viewController: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Public methods
    
    func avatarURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let imageURL = URL(string: profileImageURL)
        else { return nil }
        return imageURL
    }
    
    func updateProfileDetails() -> [String]? {
        guard let userName = profileService.profile?.name,
              let userLogin = profileService.profile?.loginName,
              let userInfo = profileService.profile?.bio
        else { return nil }
        
        return [userName, userLogin, userInfo]
    }
    
    func cleanWebCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {} )
            }
        })
    }
    
    func cleanServicesData() {
        imagesListService.clean()
        profileService.clean()
        profileImageService.clean()
        
    }
    
    func logout() {
        oauth2TokenStorage.token = nil
        viewController?.switchToSplashViewController()
        cleanWebCookies()
        cleanServicesData()
    }
}
