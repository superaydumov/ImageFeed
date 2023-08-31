//
//  DateExtension.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 30.08.2023.
//

import Foundation

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }
}
