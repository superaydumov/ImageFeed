//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 07.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var gradientView: UIView!
    
}

extension ImagesListCell {
    func configureCell(image: UIImage?, date: String, isLiked: Bool) {
        gradientViewSet(self)
        
        cellImage.image = image
        dateLabel.text = date

        let likeImage = isLiked ? UIImage(named: "like_button_ON") : UIImage(named: "like_button_OFF")
        likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListCell {
    func gradientViewSet(_ cell: ImagesListCell) {
        let gradientViewLayer = CAGradientLayer()
        let topColor = UIColor(red: 0.27, green: 0.26, blue: 0.34, alpha: 0.00)
        let bottomColor = UIColor(red: 0.27, green: 0.26, blue: 0.34, alpha: 0.20)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        gradientViewLayer.frame = gradientView.bounds
        gradientViewLayer.colors = gradientColors
        
        gradientView.backgroundColor = UIColor.clear
        gradientView.layer.insertSublayer(gradientViewLayer, at: 0)
        gradientView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
