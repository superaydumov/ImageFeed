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
}

struct URLResult: Codable {
    let full: String?
    let thumb: String?
}

struct LikePhotoResult: Codable {
    let photo: PhotoResult?
}
