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
    
    func showAlternativeAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle:.alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func extendedAlertShow(model: ExtendedAlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: model.firstButtonText, style: .default, handler: { _ in
            model.firstCompletion() })
        let secondAction = UIAlertAction(title: model.secondButtonText, style: .default, handler: { _ in
            model.secondCompletion() })
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
