//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 24.07.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    @IBOutlet weak var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
}
