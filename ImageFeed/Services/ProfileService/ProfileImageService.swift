//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.08.2023.
//

import Foundation
//podfo5-Jenqid-nypmib

final class ProfileImageService {
    
    // MARK: - Proreties
    
    static let shared = ProfileImageService()
    private init() {}
    
    private (set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Public methods
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        
        var request: URLRequest? = profileImageURLRequest(username: username)
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
                switch result {
                case .success (let body):
                    let avatarURL = body.profileImage?.small
                    guard let avatarURL else { return }
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.avatarURL = nil
                }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    private func profileImageURLRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
    }
}
