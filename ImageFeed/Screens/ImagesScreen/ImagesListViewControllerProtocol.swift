//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation
import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableView: UITableView! { get set }
    var photos: [Photo] { get set }
    
    func imagesListAlertShow()
}
