//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var viewController: ProfileViewControllerProtocol? { get set }
    
    func avatarURL() -> URL?
    func updateProfileDetails() -> [String]?
    func cleanWebCookies()
    func cleanServicesData()
    func logout()
}
