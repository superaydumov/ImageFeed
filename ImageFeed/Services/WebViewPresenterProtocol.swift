//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 14.09.2023.
//

import Foundation
import WebKit

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    
    func webViewLoading()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
