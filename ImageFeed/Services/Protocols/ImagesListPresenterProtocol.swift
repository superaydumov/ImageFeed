//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol: AnyObject {
    var viewController: ImagesListViewControllerProtocol? { get set }
    
    func fetchPhotosNextPage(indexPath: IndexPath)
    func changeLike(indexPath: IndexPath, cell: ImagesListCell)
    func updateTableViewAnimated()
}
