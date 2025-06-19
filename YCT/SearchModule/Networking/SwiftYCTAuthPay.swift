//
//  SwiftYCTAuthPay.swift
//  YCT
//
//  Created by Huzaifa Munawar on 14/12/2024.
//

import Foundation


class YCTApiAuthPay {
    let type: String
    let price: String
    let credits: String
    
    init(type: String, price: String, credits: String) {
        self.type = type
        self.price = price
        self.credits = credits
    }
    
    func start(completion: @escaping ((GenericResponse<YCTAuthPayModel>?) -> ())) {
        let params: [String: Any] = [
            "type": type,
            "price": price,
            "credits": credits,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.userPayment.url, method: .post, parameters: params) { (response: GenericResponse<YCTAuthPayModel>?, error) in
            DispatchQueue.main.async {
                completion(response)
                print(response?.data)
            }
        }
    }
    
    func purchaseCreadits(credits: String, completion: @escaping ((Bool) -> ())) {
        let params: [String: Any] = [
            "credits": credits,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        Networking.sharedInstance.genericRequest(ApiEndPoints.xunjiCredits.url, method: .post, parameters: params) { (response: GenericResponse<YCTAuthPayModel>?, error) in
            DispatchQueue.main.async {
                if response?.code == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
}

// Example response model for decoding JSON
struct YCTAuthPayModel: Codable {
    let url: String?
    let userID: String?
    let orderSn: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case orderSn = "order_sn"
        case userID = "userId"
    }
}
