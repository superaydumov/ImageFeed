//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 11.08.2023.
//

import UIKit
import WebKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let showAuthentificationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let oauth2Service = OAuth2Service.shared
    private var alertPresenter: AlertPresenterProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthentificationScreenSegueIdentifier, sender: nil)
        }
        
        alertPresenter = AlertPresenter(delegate: self)
        
//        let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти в систему!", buttonText: "Ok", completion: { [weak self] in
//            guard let self else { return }
//            
//            print ("Ok button is clicked.")
//            oauth2TokenStorage.token = nil
//        })
//        alertPresenter?.showAlert(model: alertModel)
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
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else { return }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

    // MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alertModel = AlertModel(title: "Что-то пошло не так(", message: "Не удалось войти в систему!", buttonText: "Ok", completion: { [weak self] in
                    guard let self else { return }
                    
                    print ("Ok button is clicked.")
                    oauth2TokenStorage.token = nil
                })
                alertPresenter?.showAlert(model: alertModel)
                print ("fetchOAuthToken failure case!")
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(token: token, username: data.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("Error with profile.")
                break
            }
        }
    }
}
