//
//  DateFormatters.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 09.09.2023.
//

import Foundation

struct DateFormatters {
    let iso8601 = ISO8601DateFormatter()
    let long: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
