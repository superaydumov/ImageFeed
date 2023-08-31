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
    let description: String
    let urlResult: URLresult
    
    enum CodingKeys: String, CodingKey {
        case id
        case ceatedAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct URLresult: Codable {
    let full: String
    let thumb: String
}
