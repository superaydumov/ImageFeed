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
                                baseURL: URL = Constants.defaultbaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
