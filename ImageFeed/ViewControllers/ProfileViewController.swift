//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.07.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var infoLabel: UILabel!
    private var profileImageView: UIImageView!
    private var logoutButton: UIButton!
    
    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
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
            let imageURL = URL(string: profileImageURL)
        else { return }
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: imageURL,
                                     placeholder: UIImage(named: "userpick_stub"),
                                     options: [.processor(processor)])
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration of switchToSplachViewController")}
        
        window.rootViewController = SplashViewController()
    }
    
    private func cleanWebCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {} )
            }
        })
    }
    
    // MARK: - UISetup methods
    
    private func imageUISetup() {
        let profileImage = UIImage(named: "userpick_photo")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)])
        
        self.profileImageView = imageView
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
        
        self.logoutButton = logoutButton
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
        profileImageView.image = UIImage(named: "userpick_stub")
        nameLabel.text = "User's name"
        loginLabel.text = "User's login"
        infoLabel.text = "User's information"
        
        oauth2TokenStorage.token = nil
        switchToSplashViewController()
        cleanWebCookies()
        
        logoutButton.isEnabled = false
    }
}
