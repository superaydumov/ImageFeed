//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 17.09.2023.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Public properties
    
    weak var viewController: ImagesListViewControllerProtocol?
    
    // MARK: - Private properties
    
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Public methods
    
    func fetchPhotosNextPage(indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func changeLike(indexPath: IndexPath, cell: ImagesListCell) {
        guard let indexPath = viewController?.tableView.indexPath(for: cell) else { return }
        let photo = viewController?.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        guard let photo else { return }
        
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: photo.isLiked) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.viewController?.photos = self.imagesListService.photos
                    guard let isLiked = self.viewController?.photos[indexPath.row].isLiked else { return }
                    cell.isLikedDidSet(isLiked)
                case .failure:
                    self.viewController?.imagesListAlertShow()
                    print ("There's an error with like!")
                }
                UIBlockingProgressHUD.dismiss()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = viewController?.photos.count
        let newCount = imagesListService.photos.count
        
        guard let oldCount else { return }
        
        viewController?.photos = imagesListService.photos
        if oldCount != newCount {
            viewController?.tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                viewController?.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
