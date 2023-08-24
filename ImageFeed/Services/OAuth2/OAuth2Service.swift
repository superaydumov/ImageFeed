//
//  OAuthService.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 10.08.2023.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Constants
    
    static let shared = OAuth2Service()
    private init() { }
    
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            return oauth2TokenStorage.token
        }
        set {
            oauth2TokenStorage.token = newValue
        }
    }
    
    // MARK: - Public functions 
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for:request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success (let body):
                    self.task = nil
                    self.authToken = body.accessToken
                    completion(.success(body.accessToken))
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
 
    func photosRequest(page: Int, perPage: Int) -> URLRequest {
            URLRequest.makeHTTPRequest(path: "/photos?"
                                       + "page=\(page)"
                                       + "&&per_page=\(perPage)",
                                       httpMethod: "GET")
    }
    
    func likeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "POST")
    }
    
    func unlikeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: "DELETE")
    }
    
    func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.baseURL)
    }
}
