//
//  DateFormatters.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 09.09.2023.
//

import Foundation

enum DateFormatters {
    static let iso8601 = ISO8601DateFormatter()
    static let long: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
