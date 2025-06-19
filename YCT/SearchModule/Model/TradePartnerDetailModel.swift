//
//  TradePartnerDetailModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 08/12/2024.
//

import Foundation


// MARK: - Data Model
struct TradePartnerDetailModel: Codable {
    let credits: Int?
    let data: DataContent?
    let records: [Records]? // Assuming records is an array of strings, adjust as needed.
}

// MARK: - Data Content Model
struct DataContent: Codable {
    let total: String?
    let list: [ListItem]?

    enum CodingKeys: String, CodingKey {
        case total = "Total"
        case list = "List"
    }
}

struct Records: Codable {
    var quantity: Double?
    var count: Int?
    var weight: Double?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case quantity = "Q"
        case count = "C"
        case weight = "W"
        case date
    }
}

// MARK: - List Item Model
struct ListItem: Codable {
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
    let extData: String? // If extData can be any type, change to `Any?` and use custom decoding.
    let dataId: Int?
    let hsCode: String?
    let uniqId: String?
}

