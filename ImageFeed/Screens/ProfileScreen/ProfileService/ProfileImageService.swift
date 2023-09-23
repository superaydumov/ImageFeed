//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.08.2023.
//

import Foundation

final class ProfileImageService {
    
    // MARK: - Proreties
    
    static let shared = ProfileImageService()
    private init() {}
    
    private (set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    
    private var profileImageTask: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Public methods
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self, self.avatarURL == nil else { return }
            
            self.profileImageTask?.cancel()
            
            var request: URLRequest? = profileImageURLRequest(username: username)
            request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            guard let request else { return }
            
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success (let body):
                        let avatarURL = body.profileImage?.large
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
            }
            self.profileImageTask = task
            task.resume()
        }
    }
    
    func clean() {
        avatarURL = nil
        profileImageTask?.cancel()
        profileImageTask = nil
    }
}

extension ProfileImageService {
    private func profileImageURLRequest(username: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
    }
}
