//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 10.08.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    var token: String?  {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
