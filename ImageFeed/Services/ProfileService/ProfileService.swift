//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 21.08.2023.
//

import Foundation

final class ProfileService {
    
    // MARK: - Proreties
    
    static let shared = ProfileService()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    private (set) var profile: Profile?
    
    private var task: URLSessionTask?
    
    // MARK: - Public methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        var request: URLRequest? = selfProfileRequest
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
                switch result {
                case .success (let body):
                    let profile = Profile(username: body.username,
                                          name: "\(body.firstName) \(body.lastName)",
                                          loginName: "@\(body.username)",
                                          bio: body.bio)
                    self.profile = profile
                    
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    self.profile = nil
                }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private var selfProfileRequest: URLRequest {
            URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
    }
}