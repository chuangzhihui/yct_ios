//
//  Date+Extensions.swift
//  YCT
//
//  Created by Huzaifa Munawar on 01/12/2024.
//

import Foundation
import UIKit

extension Int {
    func convertSecondsToDateString(format: String = "yyyy-MM-dd") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func toTimestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    func oneMonthAgo() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self) ?? Date.now
    }
    
    func oneMonthBefore() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self) ?? Date.now
    }
    
    /// Returns the date that is 10 days before the current date as an integer in the format `yyyyMMdd`
    func twentyDaysAgoAsInt() -> Int? {
        let calendar = Calendar.current
        if let tenDaysAgo = calendar.date(byAdding: .day, value: -20, to: Date()) {
            return tenDaysAgo.toTimestamp()
        }
        return nil
    }
}

extension Int {
    func getTotalCount(for count: Int) -> Int {
        if self > count {
            return count
        } else {
            return self
        }
    }
}


extension String {
    func getString(for dataType: Int) -> String {
        guard self == "Supplier" || self == "Suppliers" else { return self }
        return dataType == 0 ? "Suppliers" : "Buyers"
    }
    
    func checkString() -> String {
        guard !self.isEmpty else { return "UnDisclosed"}
        
        return self
    }
    
    func toArray() -> [String] {
        return self.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

extension UIViewController {
    func moveToPaymentVC() {
        let paymentVC = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        paymentVC.modalPresentationStyle = .overFullScreen
        present(paymentVC, animated: false)
    }
    
    func showPaymentOptions(price: String, credits: String, onCompletion: @escaping ((Bool) -> ())) {
        let titles = ["Alipay".localizeString(), "PayPal".localizeString()]
        let subtitles = ["", ""]
        let subIcons = ["ali_icon", "paypal_icon"]
        let defaultIndex = 3
        
        let paymentView = YCTPublishSettingBottomView.settingViewIcon(
            withDefaultIndex: defaultIndex,
            title: "Please select payment method!".localizeString(),
            titles: titles,
            icons: subIcons,
            subtitles: subtitles
        ) { [weak self] title, index in
            guard let self = self else { return }
            print("Selected Index: \(index)")
            
            let api = YCTApiAuthPay(type: "\(index + 1)", price: price, credits: credits)
            YCTHud.sharedInstance().showLoadingHud()
            api.start { response in
                YCTHud.sharedInstance().hideHud()
                if index == 1 {
                    let vc = YCTPaypalViewController()
                    guard let url = URL(string: response?.data?.url ?? "") else {
                        print("Invalid URL")
                        return
                    }
                    vc.url = url
                    
                    vc.onAuthGenericSuccess = { genericResultString in
                        YCTHud.sharedInstance().showLoadingHud()
                        api.purchaseCreadits(credits: api.credits) { status in
                            YCTHud.sharedInstance().hideHud()
                            self.dismiss(animated: true) {
                                if status {
                                    onCompletion(true)
                                } else {
                                    onCompletion(false)
                                }
                            }
                        }
                    }
                    
                    vc.onAuthCancelPayment = { cancelString in
                        self.dismiss(animated: true) {
                            onCompletion(false)
                        }
                    }
                    
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    
                } else if index == 0 {
                    AlipaySDK.defaultService().payOrder(response?.data?.url ?? "", fromScheme: "yct") { resultDic in
                        DispatchQueue.main.async {
                            if let resultDic = resultDic,
                               let status = resultDic["resultStatus"] as? String {
                                print("Payment Result: \(resultDic)")
                                if status == "9000" {
                                    self.dismiss(animated: true) {
                                        onCompletion(true)
                                        self.onAuthPaySuccess()
                                    }
                                } else {
//                                    self.dismiss(animated: true) {
                                        onCompletion(false)
//                                    }
                                }
                            } else {
//                                self.dismiss(animated: true) {
                                    onCompletion(false)
//                                }
                            }
                        }
                    }
                }
            }
        }
        
        (paymentView as AnyObject).yct_show()
    }
    
    private func onAuthPaySuccess() {
        YCTHud.sharedInstance().showSuccessHud("success".localizeString())
        //            YCTUserManager.sharedInstance().updateUserInfo()
        // Handle successful payment authorization
        print("Payment Authorization Successful")
    }
    
}

extension String {
    func localizeString() -> String {
        let languageCode = YCTSanboxTool.getCurrentLanguage() // zh-Hans // en
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") ?? ""
        if let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func getLangType() -> Int {
        switch self {
        case "zh-Hans":
            return 1
            
        case "en":
            return 0
            
        default:
            return 1
        }
    }
}
