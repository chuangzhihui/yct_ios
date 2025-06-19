//
//  Product.swift
//  YCT
//
//  Created by Lucky on 26/03/2024.
//

import Foundation

struct Product: Codable {
    let productId: Int?
    let categoryName: String?
    let categoryId: Int?
    let productName: String?
    let price: Double?
    let introduction: String?
    let media: [MediaRes]
    
    init(productId: Int?,
         categoryName: String?,
         categoryId: Int?,
         productName: String?,
         price: Double?,
         introduction: String?,
         media: [MediaRes]) {
        self.productId = productId
        self.categoryName = categoryName
        self.categoryId = categoryId
        self.productName = productName
        self.price = price
        self.introduction = introduction
        self.media = media
    }
}
