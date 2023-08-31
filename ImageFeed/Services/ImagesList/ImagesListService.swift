//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 30.08.2023.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    
    static let shared = ImagesListService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage.shared.token
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    
    // MARK: - Private methods
    
    func fetchPhotosNextPage() {
        let nextPage = nextPageDownload()
        
        assert(Thread.isMainThread)
        if task != nil { return }
        guard let token else { return }
            
        var request: URLRequest? = photosRequest(page: nextPage, perPage: 10)
        request?.addValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
            
        guard let request else { return }
            
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else { return }
                switch result {
                case .success (let body):
                    let photo = Photo(id: body.id,
                                      size: CGSize(width: body.width, height: body.height),
                                      createdAt: dateFormatter.date(from: body.createdAt),
                                      welcomeDescription: body.description,
                                      thumbImageURL: body.urlResult.thumb,
                                      largeImageURL: body.urlResult.full,
                                      isLiked: body.likedByUser)
                    self.photos.append(photo)
                    self.lastLoadedPage = nextPage
                        
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                        
                    self.task = nil
                case .failure(let error):
                    print ("There's a problem with photos downloading: (\(error)).")
                }
        }
        self.task = task
        task.resume()
    }
}

extension ImagesListService {
    private func photosRequest(page: Int, perPage: Int) -> URLRequest {
            URLRequest.makeHTTPRequest(path: "/photos?"
                                       + "page=\(page)"
                                       + "&&per_page=\(perPage)",
                                       httpMethod: "GET")
    }
    
    private func nextPageDownload () -> Int {
        guard let lastLoadedPage else { return 1 }
        
        return lastLoadedPage + 1
    }
}
