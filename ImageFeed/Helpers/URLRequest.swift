//
//  URLRequest.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 21.08.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(path: String,
                                httpMethod: String,
                                baseURL: URL? = Constants.defaultBaseURL) -> URLRequest? {
        guard let baseURL, let url = URL(string: path, relativeTo: baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
