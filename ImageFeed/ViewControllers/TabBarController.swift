//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 26.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyBoard.instantiateViewController(identifier: "ImagesListViewController") as? ImagesListViewController
        guard let imagesListViewController else { return }
        imagesListViewController.configure(ImagesListPresenter())
        
        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfilePresenter())
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "tab_profile_Active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
