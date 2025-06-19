//
//  TradeListModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 02/12/2024.
//

import Foundation

struct TradeListModel: Codable {
    var credits: Int?
    var baseInfo: BaseInfoModel?
    var data: TransactionData?
    
    enum CodingKeys: String, CodingKey {
        case credits
        case baseInfo = "BaseInfo"
        case data = "Data"
    }
}

struct BaseInfoModel: Codable {
    var address: String?
    var corporateId: Int?
    var name: String?
    var nameMd5: String?
    var country: String?
    var lastTime: Int?
    var tradeTimes: Int?
    
    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case corporateId = "CorporateId"
        case name = "Name"
        case nameMd5 = "NameMd5"
        case country = "Country"
        case lastTime = "LastTime"
        case tradeTimes = "TradeTimes"
    }
}

struct TransactionData: Codable {
    var total: String?
    var list: [TransactionModel]?
    
    enum CodingKeys: String, CodingKey {
        case total = "Total"
        case list = "List"
    }
}

struct TransactionModel: Codable {
    let productDescription: String?
    let date: Int?
    let month: String?
    let importer: String?
    let importerId: Int?
    let importerCountry: String?
    let importerAddress: String?
    let exporter: String?
    let exporterId: Int?
    let exporterCountry: String?
    let exporterAddress: String?
    let weightUnit: String?
    let quantityUnit: String?
    let quantity: Double?
    let grossWeight: Double?
    let netWeight: Double?
    let metricTon: String?
    let amountUSD: Double?
    let usdWeightUnitPrice: String?
    let usdQuantityUnitPrice: String?
    let localCurrencyAmount: String?
    let transactionCurrencyAmount: String?
    let currency: String?
    let transactionMethod: String?
    let detailedProductName: String?
    let productModelBrand: String?
    let localPort: String?
    let foreignPort: String?
    let transportMethod: String?
    let tradeMethod: String?
    let transitCountry: String?
    let billOfLading: String?
    let customsDeclaration: String?
    let declaredQuantity: Double?
    let productDescriptionLocal: String?
    let detailedProductNameLocal: String?
    let productModelBrandLocal: String?
    let exporterLocal: String?
    let importerLocal: String?
    let extData: String?
    let uniqId: String?
    let dataId: Int?
    let hsCode: String?
}
