//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 11.08.2023.
//

import UIKit
import WebKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let showAuthentificationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthentificationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthentificationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewCotroller = navigationController.viewControllers.first as? AuthViewController
            else { return }
            viewCotroller.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

    // MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                let alertModel = AlertModel(title: "Error", message: "There's a problem with token!", buttonText: "Ok", completion: { [weak self] in
                    guard let self else { return }
                    //code to write to handle pushinhg "Ok alert button
                })
                alertPresenter?.showAlert(model: alertModel)
                break
            }
        }
    }
}
