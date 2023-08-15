//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 04.08.2023.
//

import Foundation
import WebKit

final class AuthViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Private properties
    
    private let webSegueIdentifier = "ShowWebView"
    
    // MARK: - Public properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(webSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonUISetup()
    }
    
    // MARK: - Private methods
    
    private func loginButtonUISetup() {
        loginButton.layer.masksToBounds = true
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.cornerRadius = 16
    }
}

    // MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
