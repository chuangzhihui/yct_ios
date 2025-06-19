//
//  TradePortModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 03/12/2024.
//

import Foundation

// MARK: - Data Model
struct TradePortModel: Codable {
    let credits: Int?
    let baseInfo: BaseInfoModel?
    var items: [Item]?
}
