//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 04.08.2023.
//

import Foundation
import WebKit

final class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonUISetup()
    }
    
    func loginButtonUISetup() {
        loginButton.layer.masksToBounds = true
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.cornerRadius = 16
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
    }
    
}
