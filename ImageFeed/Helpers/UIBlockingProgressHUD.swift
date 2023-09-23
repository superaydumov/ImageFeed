//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 19.08.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class UIBlockingProgressHUD {
    
    struct MyIndicator: Indicator {
        var image: UIImage = UIImage()
        var imageView: UIImageView = UIImageView()
        let view: UIView = UIView()
        func startAnimatingView() { view.isHidden = false }
        func stopAnimatingView() { view.isHidden = true }
        init() {
            image = UIImage(named: "image_placeholder")!
            imageView = UIImageView(image: image)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -image.size.height/2).isActive = true
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -image.size.width/2).isActive = true
            view.contentMode = UIView.ContentMode.center
            view.backgroundColor = UIColor(named: "YP Gray")
        }
    }
    
    static func loadingIndicatorSet () {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.colorHUD = .ypWhite
        ProgressHUD.mediaSize = 35
        ProgressHUD.marginSize = 30
    }
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        loadingIndicatorSet()
        ProgressHUD.show()
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        loadingIndicatorSet()
        ProgressHUD.dismiss()
    }
}
