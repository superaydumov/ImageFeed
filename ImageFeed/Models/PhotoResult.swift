//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 30.08.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: URLResult
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case width
//        case height
//        case likedByUser = "liked_by_user"
//        case description
//        case urlResult
//    }
}

struct URLResult: Codable {
    let full: String?
    let thumb: String?
}
