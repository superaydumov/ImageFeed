//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import Foundation
import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var alertIsCalled = false
    
    var tableView: UITableView!
    
    var photos: [ImageFeed.Photo] = []
    
    func imagesListAlertShow() {
        alertIsCalled = true
    }
}
