//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 14.09.2023.
//

import Foundation
import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func webViewLoading () {
        let request = authHelper.authRequest()
        guard let request else { return }
        
        view?.load(request: request)
        
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressIsHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
