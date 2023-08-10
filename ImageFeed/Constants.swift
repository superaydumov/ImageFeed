//
//  Constants.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 01.08.2023.
//

import Foundation

struct Constants {
    let accessKey = "5cknYblskv1f9HgymUwDSz7X5dGqM9-0f1mpmVzebqU"
    let secretKey = "CH3eNm3fTDWw60be512fQT8usbv6Gfw4Z7jsYnJv9z8"
    let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    let accessScope = "public+read_user+write_likes"
    let defaultbaseURL = URL (string: "https://api.unsplash.com/")!
}
