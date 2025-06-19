//
//  CompanyTradeCountDetailViewModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 01/12/2024.
//

import Foundation

protocol CompanyTradeCountDetailDelegate: AnyObject {
    func didReceiveCompanyTradeCountDetailResponse(response: TradeCountModel?, error: String?)
    func didReceiveCompanyTradePartnerResponse(response: TradePartnerModel?, error: String?)
    func didReceiveCompanyHSCodeResponse(response: HSCodeModel?, error: String?)
    func didReceiveCompanyTradingAreaResponse(response: TradeAreaModel?, error: String?)
    func didReceiveCompanyTradePortResponse(response: TradePortModel?, error: String?)
    func didReceiveCompanyTradeRecordsResponse(response: TradeListModel?, error: String?)
}

extension CompanyTradeCountDetailDelegate {
    func didReceiveCompanyTradeCountDetailResponse(response: TradeCountModel?, error: String?) {}
    func didReceiveCompanyTradePartnerResponse(response: TradePartnerModel?, error: String?) {}
    func didReceiveCompanyHSCodeResponse(response: HSCodeModel?, error: String?) {}
    func didReceiveCompanyTradingAreaResponse(response: HSCodeModel?, error: String?) {}
    func didReceiveCompanyTradePortResponse(response: TradePortModel?, error: String?) {}
    func didReceiveCompanyTradeRecordsResponse(response: TradeListModel?, error: String?) {}
}

struct CompanyTradeCountDetailViewModel {
    weak var delegate: CompanyTradeCountDetailDelegate?
    
    func tradeCountDetailAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyDetailTradeCount.url, method: .post, parameters: params) { (response: GenericResponse<TradeCountModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyTradeCountDetailResponse(response: response?.data, error: nil)
                        
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyTradeCountDetailResponse(response: nil, error: nil)
                        
                    } else {
                        delegate?.didReceiveCompanyTradeCountDetailResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyTradeCountDetailResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
    func companuyTradePartnerAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyTradePartner.url, method: .post, parameters: params) { (response: GenericResponse<TradePartnerModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyTradePartnerResponse(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyTradePartnerResponse(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveCompanyTradePartnerResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyTradePartnerResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
    func tradeRecordsAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName,
            "page": 1,
            "pageCount": 15,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyDetailTradeList.url, method: .post, parameters: params) { (response: GenericResponse<TradeListModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyTradeRecordsResponse(response: response?.data, error: nil)
                        
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyTradeRecordsResponse(response: nil, error: nil)
                        
                    } else {
                        delegate?.didReceiveCompanyTradeRecordsResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyTradeRecordsResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
    func companuyHSCodeAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyHSCode.url, method: .post, parameters: params) { (response: GenericResponse<HSCodeModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyHSCodeResponse(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyHSCodeResponse(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveCompanyHSCodeResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyHSCodeResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
    func companyTradingAreaAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyTradingArea.url, method: .post, parameters: params) { (response: GenericResponse<TradeAreaModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyTradingAreaResponse(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyTradingAreaResponse(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveCompanyTradingAreaResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyTradingAreaResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
    func companyTradePortAPI(dataType: Int, companyName: String) {
        let params: [String: Any] = [
            "dataType": dataType,
            "name": companyName,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyTradePort.url, method: .post, parameters: params) { (response: GenericResponse<TradePortModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveCompanyTradePortResponse(response: response?.data, error: nil)
                        
                    } else if response?.code == 402 {
                        delegate?.didReceiveCompanyTradePortResponse(response: nil, error: nil)
                        
                    } else {
                        delegate?.didReceiveCompanyTradePortResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveCompanyTradePortResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
}
