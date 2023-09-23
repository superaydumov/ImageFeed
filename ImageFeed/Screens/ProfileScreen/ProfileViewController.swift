//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.07.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Public properties
    
    var presenter: ProfilePresenterProtocol?
    
    
    // MARK: - Private properties
    
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var infoLabel: UILabel!
    private var profileImageView: UIImageView!
    private var logoutButton: UIButton!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUISetup()
        logoutButtonUISetup()
        nameLabelUISetup()
        loginLabelUISetup()
        infoLabelUISetup()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        updateProfileDetails()
        updateAvatar()
    }
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public methods
    
    func updateProfileDetails() {
        var profileDetails: [String]?
        profileDetails = presenter?.updateProfileDetails()

        guard let profileDetails else { return }

        nameLabel.text = profileDetails[0]
        loginLabel.text = profileDetails[1]
        infoLabel.text = profileDetails[2]
        
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
    
    func updateAvatar() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: presenter?.avatarURL(),
                                     placeholder: UIImage(named: "userpick_stub"),
                                     options: [.processor(processor)])
    }
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration of switchToSplashViewController")}
        
        window.rootViewController = SplashViewController()
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
            self.presenter = presenter
            self.presenter?.viewController = self
        }
    
    // MARK: - Private methods
    
    private func profileAlertShow() {
        let alertModel = ExtendedAlertModel(
            title: "Пока-Пока!",
            message: "Уверены, что хотите выйти?",
            firstButtonText: "Да",
            secondButtonText: "Нет",
            firstCompletion: { [weak self] in
                guard let self else { return }
                self.presenter?.logout()
                self.logoutButton.isEnabled = false
                print ("Нажата кнопка - Да")
            },
            secondCompletion: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.logoutButton.isEnabled = true
                print ("Нажата кнопка - Нет")
            })
        alertPresenter?.extendedAlertShow(model: alertModel)
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
        
        logoutButton.accessibilityIdentifier = "logoutButton"
        
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
        profileAlertShow()
    }
}
