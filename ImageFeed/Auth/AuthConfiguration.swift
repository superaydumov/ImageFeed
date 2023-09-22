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
    static let defaultBaseURL = URL (string: "https://api.unsplash.com/")
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let baseURL = URL(string: "https://unsplash.com")
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String
    let baseURL: URL?
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL?, authURLString: String, baseURL: URL?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.baseURL = baseURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            authURLString: Constants.unsplashAuthorizeURLString,
            baseURL: Constants.baseURL)
    }
}
