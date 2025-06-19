//
//  ProductVC.swift
//  YCT
//
//  Created by Huzaifa Munawar on 10/11/2024.
//

import UIKit

enum ProductType {
    case ProductName
    case ByHSCode
}

enum CountryType {
    case Purchasing
    case Supplying
}

class ProductVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblImportExport: UILabel!
    @IBOutlet weak var viewProductName: UIView!
    @IBOutlet weak var viewHSCode: UIView!
    @IBOutlet weak var lblHSCode: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblStartTradingHours: UILabel!
    @IBOutlet weak var lblEndTradingHours: UILabel!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var lblPurchasingCountry: UILabel!
    @IBOutlet weak var lblSupplyingCountry: UILabel!
    @IBOutlet weak var txtPortOfEntry: UITextField!
    @IBOutlet weak var txtExportPort: UITextField!
    @IBOutlet weak var txtSupplier: UITextField!
    @IBOutlet weak var txtBuyer: UITextField!
    @IBOutlet weak var lblAdvanceFilterTitle: UILabel!
    @IBOutlet weak var lblDataType: UILabel!
    @IBOutlet weak var lblTradingHoursTitle: UILabel!
    @IBOutlet weak var lblBuyerTitle: UILabel!
    @IBOutlet weak var lblSupplierTitle: UILabel!
    @IBOutlet weak var lblPurchasingCountryTitle: UILabel!
    @IBOutlet weak var lblSupplyingCountryTitle: UILabel!
    @IBOutlet weak var lblPortOfEntryTitle: UILabel!
    @IBOutlet weak var lblExportPortTitle: UILabel!
    @IBOutlet weak var lblReset: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    
    // MARK: - Variable & Constants
    var productType: ProductType = .ProductName
    var selectedImportExportType: ImportExportType = .Import
    var supplierCountryCode: String?
    var buyerCountryCode: String?
    var startTime: Int?
    var endTime: Int?
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateProductType()
        let date = Date.now.oneMonthBefore()
        startTime = date.toTimestamp()
        startDate = date
        let eDate = Date.now
        endDate = eDate
        endTime = eDate.toTimestamp()
        lblStartTradingHours.text = startDate.formatToString()
        lblEndTradingHours.text = endDate.formatToString()
        lblPurchasingCountry.textColor = UIColor.hexStringToUIColor(hex: "#737373")
        lblSupplyingCountry.textColor = UIColor.hexStringToUIColor(hex: "#737373")
    }
    
    // MARK: - Custom Functions
    
    func updateProductType() {
        configureLanguage()
        switch productType {
        case .ProductName:
            configureProductName()
            
        case .ByHSCode:
            configureHSCode()
        }
    }
    
    func configureLanguage() {
        lblProductName.text = "By Product Name".localizeString()
        lblHSCode.text = "By HS Code".localizeString()
        lblAdvanceFilterTitle.text = "Advance Filters".localizeString()
        lblSearch.text = "Search".localizeString()
        lblReset.text = "Reset".localizeString()
        lblAdvanceFilterTitle.text = "Advance Filters".localizeString()
        lblDataType.text = "Data Type".localizeString()
        lblSupplierTitle.text = "Supplier".localizeString()
        lblBuyerTitle.text = "Buyer".localizeString()
        lblImportExport.text = "Import Data".localizeString()
        
        lblTradingHoursTitle.text = "Trading hours".localizeString()
        lblPurchasingCountryTitle.text = "Purchasing Country".localizeString()
        lblSupplyingCountryTitle.text = "Supplying Country".localizeString()
        lblSupplyingCountry.text = "Please select supplying country".localizeString()
        lblPurchasingCountry.text = "Please select purchasing country".localizeString()
        lblPortOfEntryTitle.text = "Port of Entry".localizeString()
        lblExportPortTitle.text = "Export Port".localizeString()
        txtExportPort.placeholder = "Please enter export port".localizeString()
        txtPortOfEntry.placeholder = "Please enter port of entry".localizeString()
        txtBuyer.placeholder = "Please enter buyer's name".localizeString()
        txtSupplier.placeholder = "Please enter suppplier's name".localizeString()
    }
    
    func configureProductName() {
        txtProductName.placeholder = "Enter the product name".localizeString()
        viewProductName.backgroundColor = UIColor.hexStringToUIColor(hex: "022EA9")
        lblProductName.textColor = UIColor.white
        viewProductName.borderWidth = 1
        viewProductName.borderColor = UIColor.clear
        
        viewHSCode.borderWidth = 1
        viewHSCode.borderColor = UIColor.hexStringToUIColor(hex: "022EA9")
        viewHSCode.backgroundColor = UIColor.white
        lblHSCode.textColor = UIColor.hexStringToUIColor(hex: "022EA9")
    }
    
    func configureHSCode() {
        txtProductName.placeholder = "Enter a customs code of 6 digits or more".localizeString()
        viewProductName.backgroundColor = UIColor.white
        lblProductName.textColor = UIColor.hexStringToUIColor(hex: "022EA9")
        viewProductName.borderWidth = 1
        viewProductName.borderColor = UIColor.hexStringToUIColor(hex: "022EA9")
        
        viewHSCode.borderWidth = 1
        viewHSCode.borderColor = UIColor.clear
        viewHSCode.backgroundColor = UIColor.hexStringToUIColor(hex: "022EA9")
        lblHSCode.textColor = UIColor.white
    }
    
    func moveToSearchCountryVC(for type: CountryType) {
        let countryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCountryVC") as! SearchCountryVC
        countryVC.onSelectedCountry = { [weak self] (countryName, countryCode) in
            switch type {
            case .Purchasing:
                self?.lblPurchasingCountry.text = countryName
                self?.buyerCountryCode = countryCode
                self?.lblPurchasingCountry.textColor = .black
            case .Supplying:
                self?.lblSupplyingCountry.text = countryName
                self?.supplierCountryCode = countryCode
                self?.lblSupplyingCountry.textColor = .black
            }
        }
        present(countryVC, animated: true, completion: nil)
    }
    
    func showImportExportVC() {
        let importExportVC = UIStoryboard(name: "FilterViews", bundle: nil).instantiateViewController(withIdentifier: "ImportExportVC") as! ImportExportVC
        if #available(iOS 16.0, *) {
            if let sheet = importExportVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return 150
                }
                sheet.detents = [customDetent]
                sheet.prefersGrabberVisible = true
            }
        } else {
            if let sheet = importExportVC.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        }
        importExportVC.type = selectedImportExportType
        
        importExportVC.tappedCallBack = { [weak self] importExportType in
            self?.lblImportExport.text = importExportType.rawValue.localizeString()
            self?.selectedImportExportType = importExportType
        }
        
        present(importExportVC, animated: true)
    }
    
    func moveToTradeRecordVC() {
        let tradeRecordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TradeRecordVC") as! TradeRecordVC
        tradeRecordVC.modalPresentationStyle = .overFullScreen
        tradeRecordVC.selectedImportExportType = selectedImportExportType
        
        var obj = CompanyListParamsModel(dataType: selectedImportExportType.getID, page: 1, pageCount: 10, buyer: txtBuyer.text, supplier: txtSupplier.text, buyerCountry: buyerCountryCode, supplierCountry: supplierCountryCode, importPort: txtPortOfEntry.text, exportPort: txtExportPort.text, startTime: startTime, endTime: endTime)
        
        if (txtBuyer.text?.isEmpty ?? false) {
            obj.buyer = nil
        }
        if (txtSupplier.text?.isEmpty ?? false) {
            obj.supplier = nil
        }
        
        if (txtPortOfEntry.text?.isEmpty ?? false) {
            obj.importPort = nil
        }
        
        if (txtExportPort.text?.isEmpty ?? false) {
            obj.exportPort = nil
        }
        let string = txtProductName.text ?? ""
        if !string.isEmpty {
            if productType == .ByHSCode {
                obj.hsCode = string.toArray()
            } else {
                obj.products = string.toArray()
            }
        }
        
        tradeRecordVC.paramModel = obj
        present(tradeRecordVC, animated: false)
    }
    
    func moveToCompanyDetailVC() {
        let companyDetailVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailVC") as! CompanyDetailVC
        companyDetailVC.modalPresentationStyle = .overFullScreen
        //        companyDetailVC.companyName = companyName
        //        companyDetailVC.dataType = dataType
        //        companyDetailVC.importExportType = importExportType
        present(companyDetailVC, animated: false)
    }
    
    // MARK: - Custom Actions
    @IBAction func productTapped(_ sender: UIButton) {
        productType = .ProductName
        txtProductName.text = ""
        updateProductType()
    }
    
    @IBAction func hsCodeTapped(_ sender: UIButton) {
        productType = .ByHSCode
        txtProductName.text = ""
        updateProductType()
    }
    
    @IBAction func startTradingHoursTapped(_ sender: UIButton) {
        DateUtility.presentDatePicker(from: self, initialDate: startDate) { [weak self] selectedDate in
            self?.startDate = selectedDate
            self?.lblStartTradingHours.text = selectedDate.formatToString()
            self?.startTime = selectedDate.toTimestamp()
        }
    }
    
    @IBAction func endTradingHoursTapped(_ sender: UIButton) {
        DateUtility.presentDatePicker(from: self, initialDate: endDate) { [weak self] selectedDate in
            self?.endDate = selectedDate
            self?.lblEndTradingHours.text = selectedDate.formatToString()
            self?.endTime = selectedDate.toTimestamp()
        }
    }
    @IBAction func purchasingCountryTapped(_ sender: UIButton) {
        moveToSearchCountryVC(for: .Purchasing)
    }
    
    @IBAction func supplyingCountryTapped(_ sender: UIButton) {
        moveToSearchCountryVC(for: .Supplying)
    }
    
    @IBAction func importExportTapped(_ sender: UIButton) {
        showImportExportVC()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        if YCTUserDataManager.sharedInstance().isLogin {
            moveToTradeRecordVC()
        } else {
            if !(UIWindow.yct_currentViewController() is YCTLoginViewController) {
                let vc = YCTLoginViewController()
                // Optional: Set login completion to retry displaying the intended module
                //                weak var weakSelf = self
                
                // Present Login View Controller
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                UIWindow.yct_currentViewController()?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        txtProductName.text = ""
        txtBuyer.text = ""
        txtSupplier.text = ""
        txtPortOfEntry.text = ""
        txtExportPort.text = ""
        buyerCountryCode = nil
        supplierCountryCode = nil
        lblPurchasingCountry.text = "Please select purchasing country".localizeString()
        lblPurchasingCountry.textColor = UIColor.hexStringToUIColor(hex: "#737373")
        
        lblSupplyingCountry.text = "Please select supplying country".localizeString()
        lblSupplyingCountry.textColor = UIColor.hexStringToUIColor(hex: "#737373")
        
        selectedImportExportType = .Import
        lblImportExport.text = selectedImportExportType.rawValue
        
        productType = .ProductName
        updateProductType()
        
        let date = Date.now.oneMonthBefore()
        startTime = date.toTimestamp()
        startDate = date
        
        let eDate = Date.now
        endDate = eDate
        endTime = eDate.toTimestamp()
        lblStartTradingHours.text = startDate.formatToString()
        lblEndTradingHours.text = endDate.formatToString()
    }
}


extension UIWindow {
    static func yct_currentViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return yct_currentViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                return yct_currentViewController(base: tab.selectedViewController)
            }
            if let presented = base?.presentedViewController {
                return yct_currentViewController(base: presented)
            }
            return base
        }
}
