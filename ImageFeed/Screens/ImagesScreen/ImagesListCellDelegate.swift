//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 05.09.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
