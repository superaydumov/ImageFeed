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
    private var authViewController: AuthViewController?
    
    private var splashScreenImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil, let token = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
            UIBlockingProgressHUD.dismiss()
        } else {
            switchToAuthViewController()
        }
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
        
        splashScreenUISetup()
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
    
    private func switchToAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        authViewController = storyBoard.instantiateViewController(identifier: "AuthViewController") as AuthViewController
        
        guard let authViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true)
    }
    
    // MARK: - SplashScreen UISetup
    
    private func splashScreenUISetup() {
        view.backgroundColor = .ypBlack
        
        let splashScreenImage = UIImage(named: "splash_screen_logo")
        let splashScreenImageView = UIImageView(image: splashScreenImage)
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashScreenImageView)
        
        NSLayoutConstraint.activate([
            splashScreenImageView.heightAnchor.constraint(equalToConstant: 78),
            splashScreenImageView.widthAnchor.constraint(equalToConstant: 75),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        self.splashScreenImageView = splashScreenImageView
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
            case .failure:
                let alertMessage = "Не удалось войти в систему!\nОшибка при получении токена."
                splashAlertShow(alertMessage: alertMessage)
                print ("fetchOAuthToken failure case!")
            }
            UIBlockingProgressHUD.dismiss()
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
                let alertMessage = "Не удалось войти в систему!\nОшибка загрузки профиля."
                splashAlertShow(alertMessage: alertMessage)
                print("Error with profile.")
                break
            }
        }
    }
    
    private func splashAlertShow(alertMessage: String) {
        let alertModel = AlertModel(title: "Что-то пошло не так(", message: alertMessage, buttonText: "Ok", completion: { [weak self] in
            guard let self else { return }
            
            print ("Ok button is clicked.")
            oauth2TokenStorage.token = nil
        })
        alertPresenter?.showAlert(model: alertModel)
    }
}
