//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 11.08.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_vc: WebViewViewController)
}
