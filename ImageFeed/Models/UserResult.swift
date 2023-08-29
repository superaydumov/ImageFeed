//
//  UserResult.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 22.08.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
