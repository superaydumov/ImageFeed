//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 07.07.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - OBOutlets
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var gradientView: UIView!
    
    // MARK: - Constants
    
    struct Keys {
        static let reuseIdentifier = "ImagesListCell"
        static let placeholderImage = "image_placeholder"
        static let likedButtonOn = "like_button_ON"
        static let likedButtonOff = "like_button_OFF"
    }
    
    private let imagesListService = ImagesListService.shared
    weak var delegate: ImagesListCellDelegate?
    
    private let animatedGradient = AnimatedGradient()
    private var animationLayer: CALayer?
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeCellGradient()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Private methods
    
    private func removeCellGradient() {
        animationLayer?.removeFromSuperlayer()
        
        likeButton.isHidden = false
        gradientView.isHidden = false
        dateLabel.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    func configureCell(using photoURLString: String, with indexPath: IndexPath) -> Bool {
        gradientViewSet(self)
        
        var status = false
        
        guard let photoURL = URL(string: photoURLString) else { return status }
        
        let placeholderImage = UIImage(named: Keys.placeholderImage)
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL,
                              placeholder: placeholderImage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.removeCellGradient()
                status = true
                
            case .failure(let error):
                self.removeCellGradient()
                print ("There's an error with placeholder picture: \(error)")
            }
        }
        
        if let date = imagesListService.photos[indexPath.row].createdAt {
            dateLabel.text = DateFormatters.long.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        return status
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
    
    func isLikedDidSet(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: Keys.likedButtonOn) : UIImage(named: Keys.likedButtonOff)
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func addCellGradient(size: CGSize) {
        let cellGradient = animatedGradient.getGradient(size: size, cornerRadius: cellImage.layer.cornerRadius)
        var positionSubLayer: UInt32 = 0
        if let subLayers = cellImage.layer.sublayers {
            positionSubLayer = UInt32(subLayers.count) + 1
        }
        cellImage.layer.insertSublayer(cellGradient, at: positionSubLayer)
        
        likeButton.isHidden = true
        gradientView.isHidden = true
        dateLabel.isHidden = true
        
        animationLayer = cellGradient
    }
}
