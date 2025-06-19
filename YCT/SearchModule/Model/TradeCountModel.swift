//
//  TradeCountModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 01/12/2024.
//

import Foundation

struct TradeCountModel: Codable {
    var credits: Int?
    var baseInfo: BaseInfo?
    var data: [GraphData]?

    enum CodingKeys: String, CodingKey {
        case credits
        case baseInfo = "BaseInfo"
        case data = "Data"
    }
}

// MARK: - BaseInfo
struct BaseInfo: Codable {
    let address: String?
    let corporateID: Int?
    let name: String?
    let nameMd5: String?
    let country: String?
    let lastTime, tradeTimes: Int?

    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case corporateID = "CorporateId"
        case name = "Name"
        case nameMd5 = "NameMd5"
        case country = "Country"
        case lastTime = "LastTime"
        case tradeTimes = "TradeTimes"
    }
}

// MARK: - GraphData
struct GraphData: Codable {
    let date: String?
    let quantity, count, weight: Double?

    enum CodingKeys: String, CodingKey {
        case date
        case quantity = "Q"
        case count = "C"
        case weight = "W"
    }
}
