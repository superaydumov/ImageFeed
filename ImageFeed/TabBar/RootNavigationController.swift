//
//  RootViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.08.2023.
//

import UIKit

final class RootNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
