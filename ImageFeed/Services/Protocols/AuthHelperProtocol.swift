//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 15.09.2023.
//

import Foundation

protocol AuthHelperProtocol: AnyObject {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
