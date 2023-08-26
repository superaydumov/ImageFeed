//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 10.08.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    var token: String?  {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                return }
            
            KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
