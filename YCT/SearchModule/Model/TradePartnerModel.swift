//
//  TradePartnerModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 02/12/2024.
//

import Foundation


// MARK: - Data Class
struct TradePartnerModel: Codable {
    let credits: Int?
    let baseInfo: BaseInfo?
    var data: [TradePartnerGraphData]?

    enum CodingKeys: String, CodingKey {
        case credits
        case baseInfo = "BaseInfo"
        case data = "Data"
    }
}


// MARK: - TradePartnerGraphData
struct TradePartnerGraphData: Codable {
    let id: String?
    let date: String?
    let quantity, count, weight: Double?
    let timeStamp: Int?

    let nameMd5: String?
    let country: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case quantity = "Q"
        case count = "C"
        case timeStamp = "T"
        case weight = "W"
        case nameMd5 = "NameMd5"
        case country = "Country"
        case name = "Name"
        case date
    }
}
