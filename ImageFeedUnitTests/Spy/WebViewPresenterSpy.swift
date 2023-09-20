//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 15.09.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ImageFeed.WebViewViewControllerProtocol?
    
    func webViewLoading() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
