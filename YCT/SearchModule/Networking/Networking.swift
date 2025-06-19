//
//  Networking.swift
//
//


import Foundation
import UIKit
import Alamofire

enum ApiType: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

struct GenericResponse <T: Codable>:Codable {
    let code: Int?
    let msg: String?
    let data: T?
}

enum ApiEndPoints {
    
    case companyList
    case companyDetail
    case companyDetailTradeCount
    case companyDetailTradeList
    case transactionRecordDetails
    case companyTradePartner
    case companyHSCode
    case companyTradingArea
    case companyTradePort
    case contactDetail
    case tradePartnerOverviewDetail
    case userPayment
    case xunjiCredits
    
    var url: String {
        let baseUrl: String = Constants.baseUrl
        
        switch self {
        case .companyList:
            return baseUrl + "xunji/list"
            
        case .companyDetail:
            return baseUrl + "xunji/details"
            
        case .companyDetailTradeCount:
            return baseUrl + "xunji/company/tradeCount"
            
        case .companyDetailTradeList:
            return baseUrl + "xunji/company/tradeList"
            
        case .transactionRecordDetails:
            return baseUrl + "xunji/list"
            
        case .companyTradePartner:
            return baseUrl + "xunji/company/tradePartner"
            
        case .companyHSCode:
            return baseUrl + "xunji/company/HsCode"
            
        case .companyTradingArea:
            return baseUrl + "xunji/company/tradeCountry"
            
        case .companyTradePort:
            return baseUrl + "xunji/company/tradePort"
            
        case .contactDetail:
            return baseUrl + "xunji/company/contact"
            
        case .tradePartnerOverviewDetail:
            return baseUrl + "xunji/company/partnerDetails"
            
        case .userPayment:
            return baseUrl + "user/payment"
            
        case .xunjiCredits:
            return baseUrl + "xunji/credits"
        }
    }
}

class Networking {
    
    static let sharedInstance: Networking = Networking()
    let session = URLSession.shared
    var authApiCallCount = 0
    
    public func genericRequest<T: Decodable>(_ apiName: String = "", method: ApiType , parameters: [String:Any]?  , completion: @escaping(_ response: T?,_ error:String?) -> Void) {
        
        self.apiCall(apiName, method: method.rawValue, parameters: parameters) { response, error in
            if error == nil {
                
                do {
                    let decorder = JSONDecoder()
                    let response = try decorder.decode(T.self, from: response ?? Data())
                    
                    completion(response, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                    //                    completion(nil, "Something went wrong! Please try again later!")
                }
            }else {
                completion(nil, error)
            }
        }
    }
    
    
    //    post API call
    func apiCall(_ apiName: String,method:String, parameters: [String: Any]? , completion: @escaping(_ response: Data?,_ error: String?) -> Void) {
        
        var Url = String(format: apiName)
        
        guard let serviceUrl = URL(string: Url) else {
            print("can't make url rom string")
            return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = method
        
        let userToken = YCTUserDataManager.sharedInstance().loginModel.token
        let tokenValue = userToken.isEmpty ? ServiceManager.shared.token : userToken

        request.setValue(tokenValue, forHTTPHeaderField: "token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let parameters = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters as Any, options: []) else { return }
            if let jsonText = String(data: httpBody, encoding: .utf8) {
                print( jsonText)
                
            }
            request.httpBody = httpBody
        }
        print("API Call: \n", serviceUrl)
        print("Header: \n",request.allHTTPHeaderFields!)
        print("Parameters: \n", parameters)
        let dataTask = session.dataTask(with: request) { data, response, error in
            print("API Response: \n", serviceUrl)
            
            //            error = "The request timed out."
            if error == nil {
                guard let jsonData = data else {
                    completion(nil,"No response in API")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                    
                    self.authApiCallCount = 0
                    completion(jsonData , nil)
                    print("Response call: \n",String(data: jsonData, encoding: .utf8) ?? "")
                }
                
            } else {
                completion(nil, error?.localizedDescription)
            }
        }.resume()
    }
}
