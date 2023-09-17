//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func switchToSplashViewController()
}
