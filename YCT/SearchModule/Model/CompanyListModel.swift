//
//  CompanyListModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 30/11/2024.
//

import Foundation


struct CompanyListModel: Codable {
    let credits: Int?
    let total: Int?
    var lists: [List]?
    
    enum CodingKeys: String, CodingKey {
        case credits
        case total = "Total"
        case lists = "List"
    }
}

struct List: Codable {
    let id: String?
    let corporate: String?
    let corporateID: Int?
    let country: String?
    let hsCode: String?
    let accTime: Int?
    let tradeCorporate: String?
    let tradeCorporateID: Int?
    let tradeCountry: String?
    let products: String?
    let importPort: String?
    let exportPort: String?
    let quantity: Double?
    let weight: Double?
    let amount: Double?
    let ladingNumber: String?
    let declarationNumber: String?
    let weightUnit: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporate
        case corporateID = "corporate_id"
        case country
        case hsCode = "hs_code"
        case accTime = "acctime"
        case tradeCorporate = "trade_corporate"
        case tradeCorporateID = "trade_corporate_id"
        case tradeCountry = "trade_country"
        case products
        case importPort = "import_port"
        case exportPort = "export_port"
        case quantity
        case weight
        case amount
        case ladingNumber = "lading_number"
        case declarationNumber = "declaration_number"
        case weightUnit = "weight_unit"
    }
}
