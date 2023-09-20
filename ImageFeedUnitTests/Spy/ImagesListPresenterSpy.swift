//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Эльдар Айдумов on 18.09.2023.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewController: ImageFeed.ImagesListViewControllerProtocol?
    var updateIsCalled = false
    var changeLike = false
    var fetchIsCalled = false
    
    func fetchPhotosNextPage(indexPath: IndexPath) {
        fetchIsCalled = true
    }
    
    func changeLike(indexPath: IndexPath, cell: ImageFeed.ImagesListCell) {
        changeLike = true
    }
    
    func updateTableViewAnimated() {
        updateIsCalled = true
    }
}
