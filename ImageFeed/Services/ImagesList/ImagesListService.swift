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
    
    private struct Keys {
        static let noURLRequestThumb = "There's no thumb."
        static let noURLRequestFull = "There's no full size for photo."
    }
    
    // MARK: - Private methods
    
    func fetchPhotosNextPage() {
        let nextPage = nextPageDownload()

        assert(Thread.isMainThread)
        if task != nil { return }
        guard let token = token else { return }

        var request: URLRequest? = photosRequest(page: nextPage, perPage: 10)
        request?.addValue("Bearer \(token))", forHTTPHeaderField: "Authorization")

        guard let request else { return }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success (let body):
                    body.forEach { photo in
                        self.photos.append(Photo(id: photo.id,
                                                 size: CGSize(width: photo.width, height: photo.height),
                                                 createdAt: photo.createdAt?.dateTimeString,
                                                 welcomeDescription: photo.description,
                                                 thumbImageURL: photo.urls.thumb ?? Keys.noURLRequestThumb,
                                                 largeImageURL: photo.urls.full ?? Keys.noURLRequestFull,
                                                 isLiked: photo.likedByUser))
                    }
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
