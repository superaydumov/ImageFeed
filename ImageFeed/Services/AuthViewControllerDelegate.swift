//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 11.08.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
