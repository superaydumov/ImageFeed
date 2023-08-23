//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var label: UILabel?
    
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var infoLabel: UILabel!
    
    private let profileService = ProfileService.shared
    
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUISetup()
        logoutButtonUISetup()
        nameLabelUISetup()
        loginLabelUISetup()
        infoLabelUISetup()
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile else { return }
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        infoLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            })
        
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        // TODO: update avatar using KingFisher
    }
    
    // MARK: - UISetup methods
    
    private func imageUISetup() {
        let profileImage = UIImage(named: "userpick_stub")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)])
    }
    
    private func logoutButtonUISetup() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: self,
            action: #selector(Self.didTapLogoutButton))
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
    }
    
    private func nameLabelUISetup() {
        let nameLabel = UILabel()
        nameLabel.text = "Name label"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
        
        self.nameLabel = nameLabel
    }
    
    private func loginLabelUISetup() {
        let loginLabel = UILabel()
        loginLabel.text = "Login label"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGray
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 145).isActive = true
       
        self.loginLabel = loginLabel
    }
    
    private func infoLabelUISetup() {
        let infoLabel = UILabel()
        infoLabel.text = "Information label"
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textColor = .ypWhite
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        
        infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 169).isActive = true
        
        self.infoLabel = infoLabel
    }
    
    // MARK: - @objc methods
    @objc
    private func didTapLogoutButton() {
        label?.removeFromSuperview()
        label = nil
    }
}
