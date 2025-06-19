//
//  ContactDetailModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 07/12/2024.
//

import Foundation



// MARK: - DataModel
struct ContactDetailModel: Codable {
    let credits: Int?
    let company: CompanyModel?
    let contacts: [ContactData]?
}

// MARK: - CompanyModel
struct CompanyModel: Codable {
    let company: String?
    let companyCN: String?
    let domain: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case company = "Company"
        case companyCN = "CompanyCN"
        case domain = "Domain"
        case country = "Country"
    }
}

// MARK: - ContactModel
struct ContactData: Codable {
    let type: String?
    let name: String?
    let value: String?
    let position: String?
    let label: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case name = "Name"
        case value = "Value"
        case position = "Position"
        case label = "Label"
    }
}
