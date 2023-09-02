//
//  ViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 04.07.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        updateImagesList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController, let indexPath = sender as? IndexPath {
                let image = UIImage(named: photosName[indexPath.row])
                viewController.image = image
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    
    private func updateImagesList() {
        UIBlockingProgressHUD.show()
        
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
                })
        updateTableViewAnimated()
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

    // MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.Keys.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        let photo = photos[indexPath.row]
        let configuringCellStatus = cell.configureCell(using: photo.thumbImageURL, with: indexPath)
        cell.isLikedDidSet(photo.isLiked)
        
        if configuringCellStatus {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        UIBlockingProgressHUD.dismiss()
        return cell
    }
}

    // MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
