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
        
        let task = profileObject(for: request) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success (let body):
                    let profile = Profile(userName: body.userName,
                                          name: "\(body.firstName)" + " " + "\(body.lastName)",
                                          loginName: "@\(body.userName)",
                                          bio: body.bio)
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    self.profile = nil
                }
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
    
    private func profileObject(for request: URLRequest,
                        completion: @escaping (Result<ProfileResult, Error>) -> Void)
    -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
}