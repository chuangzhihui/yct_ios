//
//  TradeAreaModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 03/12/2024.
//

import Foundation


struct TradeAreaModel: Codable {
    let credits: Int?
    let baseInfo: BaseInfo?
    var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case credits
        case baseInfo
        case items
    }
}

// Item model
struct Item: Codable {
    let country: String?
    let port: String?
    let quantity: Double?
    let count: Int?
    let timeStamp: Int?
    let weight: Double?

    enum CodingKeys: String, CodingKey {
        case port
        case country
        case quantity = "Q"
        case count = "C"
        case timeStamp = "T"
        case weight = "W"
    }
}
