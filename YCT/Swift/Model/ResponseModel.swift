//
//  ResponseModel.swift
//  YCT
//
//  Created by Lucky on 26/03/2024.
//

import Foundation

struct ResponseModel<T: Decodable>: Decodable {
    let msg: String
    let data: T
    let code: Int
}
