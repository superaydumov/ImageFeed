//
//  ExtendedAlertModel.swift
//  ImageFeed
//
//  Created by Эльдар Айдумов on 07.09.2023.
//

import Foundation

struct ExtendedAlertModel {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String
    let firstCompletion: () -> Void
    let secondCompletion: () -> Void
}
