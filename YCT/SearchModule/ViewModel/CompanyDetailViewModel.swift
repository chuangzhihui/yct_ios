//
//  CompanyDetailViewModel.swift
//  YCT
//
//  Created by Huzaifa Munawar on 01/12/2024.
//

import Foundation

protocol CompanyDetailViewModelDelegate: AnyObject {
    func didReceiveDetailResponse(response: CompanyDetailModel?, error: String?)
}

struct CompanyDetailViewModel {
    
    weak var delegate: CompanyDetailViewModelDelegate?
    
    func comopanyDetailAPI(tradeID: String, dataType: Int) {
        let params: [String: Any] = [
            "dataType": dataType,
            "id": tradeID,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        
        Networking.sharedInstance.genericRequest(ApiEndPoints.companyDetail.url, method: .post, parameters: params) { (response: GenericResponse<CompanyDetailModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveDetailResponse(response: response?.data, error: nil)
                        
                    }  else if response?.code == 402 {
                        delegate?.didReceiveDetailResponse(response: nil, error: nil)
                        
                    } else {
                        delegate?.didReceiveDetailResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveDetailResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
}
