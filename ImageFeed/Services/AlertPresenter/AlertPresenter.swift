//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 16.08.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init (delegate: UIViewController) {
        self.delegate = delegate
    }
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle:.alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        delegate?.presentedViewController?.present(alert, animated: true, completion: nil)
    }
}
