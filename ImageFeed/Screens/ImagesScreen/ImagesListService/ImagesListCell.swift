//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 07.07.2023.
//

import UIKit

public final class ImagesListCell: UITableViewCell {
    
    // MARK: - OBOutlets
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var gradientView: UIView!
    
    // MARK: - Constants
    
    struct Keys {
        static let reuseIdentifier = "ImagesListCell"
        static let likedButtonOn = "like_button_ON"
        static let likedButtonOff = "like_button_OFF"
    }
    
    private let imagesListService = ImagesListService.shared
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Lifecycle
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
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
                
        cellImage.kf.indicatorType = .custom(indicator: UIBlockingProgressHUD.MyIndicator())
        cellImage.kf.setImage(with: photoURL) { result in
            switch result {
            case .success(_):
                status = true
            case .failure(let error):
                print ("There's an error with picture: \(error)")
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
}
