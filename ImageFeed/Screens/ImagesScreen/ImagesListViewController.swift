//
//  ViewController.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 04.07.2023.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Public properties
    
    var presenter: ImagesListPresenterProtocol?
    var photos: [Photo] = []
    
    // MARK: - Public methods
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.viewController = self
    }
    
    // MARK: - Private properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        alertPresenter = AlertPresenter(delegate: self)
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        updateImagesList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController, let indexPath = sender as? IndexPath {
                viewController.largeImageURL = URL(string: photos[indexPath.row].largeImageURL)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public methods
    
    func imagesListAlertShow() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так!",
            message: "Не удалось поставить лайк.",
            buttonText: "Ок",
            completion: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            })
        alertPresenter?.showAlternativeAlert(model: alertModel)
    }
    
    func updateImagesList() {
        UIBlockingProgressHUD.show()
        
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.presenter?.updateTableViewAnimated()
                })
        presenter?.updateTableViewAnimated()
    }
}

    // MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.Keys.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        cell.delegate = self
        
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
        if indexPath.row + 1 == photos.count {
            presenter?.fetchPhotosNextPage()
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

    // MARK: -ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLike(indexPath: indexPath, cell: cell)
    }
}
