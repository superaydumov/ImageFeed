//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 14.09.2023.
//

import Foundation

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressIsHidden(_ isHidden: Bool)
}
