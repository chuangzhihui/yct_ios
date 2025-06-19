//
//  HSCodeModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 03/12/2024.
//

import Foundation


// Data container
struct HSCodeModel: Codable {
    let credits: Int?
    let baseInfo: BaseInfo?
    var data: [TradeData]?

    enum CodingKeys: String, CodingKey {
        case credits
        case baseInfo = "BaseInfo"
        case data = "Data"
    }
}

// Trade data
struct TradeData: Codable {
    let hsCode: String?
    let quantity: Double?
    let count: Int?
    let timeSTamp: Int?
    let weight: Double?
    let p: String?
    let a: String?

    enum CodingKeys: String, CodingKey {
        case hsCode
        case quantity = "Q"
        case count = "C"
        case timeSTamp = "T"
        case weight = "W"
        case p = "P"
        case a = "A"
    }
}

