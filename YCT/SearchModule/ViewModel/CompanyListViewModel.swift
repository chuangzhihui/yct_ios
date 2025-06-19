//
//  ProductViewModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 30/11/2024.
//

import Foundation

/*
    "dataType": 0, // 0 For Import Data, 1 For Export Data.
    "page": 1, // 1-500
    "pageCount": 1 // 1-20
    "products": [], // List of product names.
    "hsCode": [], // List of Hs Codes.
    "buyer": "", // Buyer name
    "supplier": "", // Supplier name
    "buyerCountry": "", // Buyer country 2 digit code. pk for pakistan
    "supplierCountry": "", // Supplier country 2 digit code. pk for pakistan
    "importPort": "", // Import Port.
    "exportPort": "", // Export Port.
    "startTime": 0, // Timestamp
    "endTime": 0 // Timestamp
 */

protocol CompanyListViewModelDelegate: AnyObject {
    func didReceiveProductResponse(response: CompanyListModel?, error: String?)
    func didReceiveTradePartnerOverviewDetail(response: TradePartnerDetailModel?, error: String?)
}

extension CompanyListViewModelDelegate {
    func didReceiveTradePartnerOverviewDetail(response: TradePartnerDetailModel?, error: String?) {}
}

struct CompanyListParamsModel {
    var dataType: Int
    var page: Int
    var pageCount: Int
    var products: [String]?
    var hsCode: [String]?
    var buyer: String?
    var supplier: String?
    var buyerCountry: String?
    var supplierCountry: String?
    var importPort: String?
    var exportPort: String?
    var startTime: Int?
    var endTime: Int?
    var name: String?
    var id: String?
}

struct CompanyListViewModel {
    
    weak var delegate: CompanyListViewModelDelegate?
    
    func companyListAPI(obj: CompanyListParamsModel, isFromSearch: Bool = false) {
        var params: [String: Any] = [
            "dataType": obj.dataType,
            "page": obj.page,
            "pageCount": obj.pageCount,
            "isFromSearch": isFromSearch,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        if obj.supplier != nil {
            params["supplier"] = obj.supplier ?? ""
        }
        
        if obj.buyer != nil {
            params["buyer"] = obj.buyer ?? ""
        }
        
        if obj.buyerCountry != nil {
            params["buyerCountry"] = (obj.buyerCountry ?? "").lowercased()
        }
        
        if obj.supplierCountry != nil {
            params["supplierCountry"] = (obj.supplierCountry ?? "").lowercased()
        }
        
        if obj.startTime != nil {
            params["startTime"] = obj.startTime ?? 0
        }
        
        if obj.endTime != nil {
            params["endTime"] = obj.endTime ?? 0
        }
        
        if obj.importPort != nil {
            params["importPort"] = obj.importPort ?? ""
        }
        
        if obj.exportPort != nil {
            params["exportPort"] = obj.exportPort ?? ""
        }
        
        if obj.products != nil {
            params["products"] = obj.products ?? []
        }
        
        if obj.hsCode != nil {
            params["hsCode"] = obj.hsCode ?? []
        }
        
        if obj.name != nil {
            params["name"] = obj.name ?? ""
        }
        
        if obj.id != nil {
            params["id"] = obj.id ?? ""
        }
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyList.url, method: .post, parameters: params) { (response: GenericResponse<CompanyListModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveProductResponse(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveProductResponse(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveProductResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveProductResponse(response: nil, error: error)
//                }
            }
        }
    }
    
    func supplierOverViewDetailAPI(parmas: [String: Any]) {
        Networking.sharedInstance.genericRequest(ApiEndPoints.tradePartnerOverviewDetail.url, method: .post, parameters: parmas) { (response: GenericResponse<TradePartnerDetailModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveTradePartnerOverviewDetail(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveTradePartnerOverviewDetail(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveTradePartnerOverviewDetail(response: nil, error: response?.msg)
                    }
//                } else {
//                    delegate?.didReceiveTradePartnerOverviewDetail(response: nil, error: response?.msg)
//                }
            }
        }
    }
}
