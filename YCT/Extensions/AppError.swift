//
//  AppError.swift
//  YCT
//
//  Created by Lucky on 21/03/2024.
//

import Foundation

struct AppError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }

    init(message: String) {
        self.message = message
    }
}
