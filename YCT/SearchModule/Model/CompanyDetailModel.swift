//
//  CompanyDetailModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 01/12/2024.
//

import Foundation


import Foundation

struct CompanyDetailModel: Codable {
    let credits: Int?
    let dataId: Int?
    let uniqId: String?
    let hsCode: String?
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
    let amountUSD: Double?
    let currency: String?
    let transactionMethod: String?
    let detailedProductName: String?
    let productSpecifications: String?
    let localPort: String?
    let foreignPort: String?
    let transportationMethod: String?
    let tradeMethod: String?
    let billOfLadingNumber: String?
    let declarationNumber: String?
    let declaredQuantity: Double?
}
