//
//  Constants.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 01.08.2023.
//

import Foundation

struct Constants {
    static let accessKey = "5cknYblskv1f9HgymUwDSz7X5dGqM9-0f1mpmVzebqU"
    static let secretKey = "CH3eNm3fTDWw60be512fQT8usbv6Gfw4Z7jsYnJv9z8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultbaseURL = URL (string: "https://api.unsplash.com/")!
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let baseURL = URL(string: "https://unsplash.com")!
}
