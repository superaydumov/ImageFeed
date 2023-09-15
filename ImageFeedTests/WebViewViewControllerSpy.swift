//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 15.09.2023.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var isLoadCalled = false
    
    func load(request: URLRequest) {
        isLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressIsHidden(_ isHidden: Bool) {
        
    }
}
