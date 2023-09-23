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
    private var fetchPhotosTask: URLSessionTask?
    private var likeTask: URLSessionTask?
    private let perPage = 10
    
    static let shared = ImagesListService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage.shared.token
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private struct Keys {
        static let noURLRequestThumb = "There's no thumb."
        static let noURLRequestFull = "There's no full size for photo."
    }
    
    // MARK: - Public methods
    
    func fetchPhotosNextPage() {
        let nextPage = nextPageDownload()

        assert(Thread.isMainThread)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self, self.fetchPhotosTask == nil else { return }

            self.fetchPhotosTask?.cancel()

            guard let token = self.token else { return }

            var request: URLRequest? = photosRequest(page: nextPage, perPage: perPage)
            request?.addValue("Bearer \(token))", forHTTPHeaderField: "Authorization")

            guard let request else { return }

            let task = self.urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success (let body):
                        body.forEach { photo in
                            let date = DateFormatters.iso8601.date(from: photo.createdAt ?? "")
                            self.photos.append(Photo(id: photo.id,
                                                     size: CGSize(width: photo.width, height: photo.height),
                                                     createdAt: date,
                                                     welcomeDescription: photo.description,
                                                     thumbImageURL: photo.urls.small ?? Keys.noURLRequestThumb,
                                                     largeImageURL: photo.urls.full ?? Keys.noURLRequestFull,
                                                     isLiked: photo.likedByUser))
                        }
                        self.lastLoadedPage = nextPage

                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos])

                        self.fetchPhotosTask = nil
                    case .failure(let error):
                        print ("There's a problem with photos downloading: (\(error)).")
                    }
                }
            }
            self.fetchPhotosTask = task
            task.resume()
        }
    }


    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self, self.likeTask == nil else { return }

            self.likeTask?.cancel()

            guard let token = self.token else {
                completion(.failure(NetworkError.urlSessionError))
                print("changeLike method token error")
                return
            }

            var request: URLRequest?
            if isLike {
                request = unlikeRequest(photoId: photoId)
            } else {
                request = likeRequest(photoId: photoId)
            }

            request?.addValue("Bearer \(token))", forHTTPHeaderField: "Authorization")

            guard let request else {
                completion(.failure(NetworkError.urlSessionError))
                print("changeLike method request error")
                return
            }

            let task = self.urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
                guard let self else {
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                DispatchQueue.main.async {
                    switch result {
                    case .success (let body):
                        let likedByUser = body.photo?.likedByUser ?? false
                        if let index = self.photos.firstIndex(where: {$0.id == body.photo?.id}) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(id: photo.id,
                                                 size: photo.size,
                                                 createdAt: photo.createdAt,
                                                 welcomeDescription: photo.welcomeDescription,
                                                 thumbImageURL: photo.thumbImageURL,
                                                 largeImageURL: photo.largeImageURL,
                                                 isLiked: likedByUser)

                            self.photos[index] = newPhoto
                        }
                        completion(.success(likedByUser))
                        self.likeTask = nil
                        print("changeLike method success case.")

                    case .failure(let error):
                        completion(.failure(error))
                        print ("There's a problem with like request: \(error).")
                    }
                }
            }
            self.likeTask = task
            task.resume()
        }
    }
    
    func clean() {
        photos = []
        lastLoadedPage = nil
        fetchPhotosTask?.cancel()
        fetchPhotosTask = nil
        likeTask?.cancel()
        likeTask = nil
    }
}

extension ImagesListService {
    private func photosRequest(page: Int, perPage: Int) -> URLRequest? {
            URLRequest.makeHTTPRequest(path: "/photos?"
                                       + "page=\(page)"
                                       + "&&per_page=\(perPage)",
                                       httpMethod: "GET")
    }
    
    private func likeRequest(photoId: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "POST")
    }
    
    private func unlikeRequest(photoId: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "DELETE")
    }
    
    private func nextPageDownload () -> Int {
        guard let lastLoadedPage else { return 1 }
        
        return lastLoadedPage + 1
    }
}
