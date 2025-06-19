//
//  ServiceManager.swift
//  Motion2Coach
//
//  Created by nawaz on 1/24/23.
//

import Foundation
import Alamofire
import SDWebImage

class ServiceManager {
    
    //------------------------------------
    // MARK: Properties
    //------------------------------------
    
    static let shared = ServiceManager()
    private let manager = AF
    private var headers = HTTPHeaders()
    var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMjAwOSJ9.ebBCfupohSACpMgw-ZPUTQ-ebYIROHYBBm6iCQ8Myv0"
    //------------------------------------
    // MARK: Configure
    //------------------------------------
    
    private init() {
        
    }
    
    
    private func setupManager() {
        
        manager.session.configuration.timeoutIntervalForRequest = ServiceConstants.ServiceError.timeOutInterval
        
        let userToken = YCTUserDataManager.sharedInstance().loginModel.token
        headers = [
            "token" : userToken.isEmpty ? self.token : userToken,
            "Content-Type" :  "application/json",
            "Accept" : "application/json"
        ]
    }
    
    
    //=======================================
    // MARK: Methods
    //=======================================
    
    //Upload Video
    
    
    
    //Post request without header
    func PostRequestWithHeader(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            setupManager()
            let apiUrl = ServiceUrls.baseUrl + url
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------URL--------------------------------->>")
                print(apiUrl)
                print("======================================================================")
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        success(responseDict)
                    }
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }
    
    
    //Post request without header
    func PostRequestWithHeaderVideo(url: String, parameters: Parameters?, success: @escaping (Any) -> Void, failure: @escaping (ServiceError) -> Void) {
        print("<<---------------------------------Request URL--------------------------------->>")
        if (NetworkReachability.isAvailable)
        {
            setupManager()
            let apiUrl = ServiceUrls.baseUrlVideo + url
            manager.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<505).responseJSON { (response) in
                print("<<---------------------------------URL--------------------------------->>")
                print(apiUrl)
                print("======================================================================")
                print("<<---------------------------------Request Response--------------------------------->>")
                print(response)
                
                print("======================================================================")
                switch response.result {
                    
                case .success(let json):
                    
                    if let responseDict = json as? NSDictionary{
                        success(responseDict)                        
                    }
                case .failure(let error):
                    var serviceError = ServiceError()
                    if error._code == NSURLErrorTimedOut {
                        serviceError.status = ServiceConstants.ServiceError.timeout
                        serviceError.message = ServiceConstants.ServiceError.timeoutError
                    } else {
                        print(error.localizedDescription)
                        serviceError.status = ServiceConstants.ServiceError.generic
                        serviceError.message = error.localizedDescription
                        
                        if error.localizedDescription == "Request failed: unauthorized (401)" {
                            
                        }
                    }
                    
                    failure(serviceError)
                }
            }
        }
        else
        {
            let serviceError = ServiceError(status: ServiceConstants.ServiceError.internet, message: ServiceConstants.ServiceError.internetError)
            failure(serviceError)
        }
        
    }

}
