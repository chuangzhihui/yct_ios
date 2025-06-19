//
//  ContactDetailVM.swift
//  YCT
//
//  Created by Huzaifa Munawar on 07/12/2024.
//

import Foundation

protocol ContactDetailDelegate: AnyObject {
    func didReceiveContactDetailResponse(response: ContactDetailModel?, error: String?)
}

struct ContactDetailVM {
    weak var delegate: ContactDetailDelegate?
    
    func contactDetailAPI(companyName: String) {
        let params: [String: Any] = [
            "name": companyName,
            "langType": YCTSanboxTool.getCurrentLanguage().getLangType()
        ]
        Networking.sharedInstance.genericRequest(ApiEndPoints.contactDetail.url, method: .post, parameters: params) { (response: GenericResponse<ContactDetailModel>?, error) in
            DispatchQueue.main.async {
//                if error == nil {
                    if response?.code == 1 {
                        delegate?.didReceiveContactDetailResponse(response: response?.data, error: nil)
                    } else if response?.code == 402 {
                        delegate?.didReceiveContactDetailResponse(response: nil, error: nil)
                    } else {
                        delegate?.didReceiveContactDetailResponse(response: nil, error: response?.msg ?? "")
                    }
//                } else {
//                    delegate?.didReceiveContactDetailResponse(response: nil, error: response?.msg ?? "")
//                }
            }
        }
    }
    
}
