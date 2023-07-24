//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userpickImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
    
}
