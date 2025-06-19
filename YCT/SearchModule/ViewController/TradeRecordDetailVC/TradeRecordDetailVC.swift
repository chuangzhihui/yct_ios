//
//  RecordVC.swift
//  FtozonUIKit
//
//  Created by Ali Wadood on 11/11/24.
//

import UIKit
import CountryPicker

enum BuyerSupplierDataType: String {
    case Buyer
    case Supplier
    
    var getType: Int {
        switch self {
        case .Buyer:
            1
        case .Supplier:
            0
        }
    }
}

class TradeRecordDetailVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblBillLandNum: UILabel!
    @IBOutlet weak var lblPortEntry: UILabel!
    @IBOutlet weak var lblExportPort: UILabel!
    @IBOutlet weak var lblHSCode: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTransportMode: UILabel!
    @IBOutlet weak var lblTradingProducts: UILabel!
    @IBOutlet weak var lblBuyerCompanyName: UILabel!
    @IBOutlet weak var lblBuyerCountry: UILabel!
    @IBOutlet weak var lblSupplierCompanyName: UILabel!
    @IBOutlet weak var lblSupplierCountry: UILabel!
    
    @IBOutlet weak var lblTradeInfoTitle: UILabel!
    @IBOutlet weak var lblProductStatusTitle: UILabel!
    @IBOutlet weak var lblBuyerInfoTitle: UILabel!
    @IBOutlet weak var lblSupplierInfoTitle: UILabel!
    @IBOutlet weak var lblTransactionDateTitle: UILabel!
    @IBOutlet weak var lblBillLandTitle: UILabel!
    @IBOutlet weak var lblTransportModeTitle: UILabel!
    @IBOutlet weak var lblPortOfEntryTitle: UILabel!
    @IBOutlet weak var lblExportPortTitle: UILabel!
    
    @IBOutlet weak var lblHSCodeTitle: UILabel!
    @IBOutlet weak var lblQuantityTitle: UILabel!
    @IBOutlet weak var lblWeightTitle: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    @IBOutlet weak var lblTradingProductTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblCountryTitle: UILabel!
    @IBOutlet weak var lblSCompanyNameTitle: UILabel!
    @IBOutlet weak var lblSCountryNameTitle: UILabel!
    
    
    // MARK: - Variable & Constants
    var selectedImportExportType: ImportExportType = .Import
    var isFromOverview: Bool = false
    var dataType: Int = 0
    var tradeID: String?
    var companyDetailVM: CompanyDetailViewModel = CompanyDetailViewModel()
    var companyDetailData: CompanyDetailModel?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        companyDetailVM.delegate = self
        configureLanguage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLoader()
        companyDetailVM.comopanyDetailAPI(tradeID: tradeID ?? "", dataType: isFromOverview ? dataType : selectedImportExportType.getID)
    }
    
    // MARK: - Custom Functions
    func configureLanguage() {
        lblHeader.text = "Trade Records".localizeString()
        lblTradeInfoTitle.text = "Trade Information".localizeString()
        lblProductStatusTitle.text = "Product status".localizeString()
        lblBuyerInfoTitle.text = "Buyer Information".localizeString()
        lblSupplierInfoTitle.text = "Supplier Information".localizeString()
        lblTransactionDateTitle.text = "Transaction Date".localizeString()
        lblBillLandTitle.text = "Bill of Landing Number".localizeString()
        lblTransportModeTitle.text = "Mode of transport".localizeString()
        lblPortOfEntryTitle.text = "Port of entry".localizeString()
        lblExportPortTitle.text = "Export Port".localizeString()
        
        lblHSCodeTitle.text = "HS Code".localizeString()
        lblQuantityTitle.text = "Quantity".localizeString()
        lblWeightTitle.text = "Weight".localizeString()
        lblAmountTitle.text = "Amount (USD)".localizeString()
        lblTradingProductTitle.text = "Trading Products".localizeString()
        lblCompanyNameTitle.text = "Company Name".localizeString()
        lblCountryTitle.text = "Country".localizeString()
        lblSCompanyNameTitle.text = "Company Name".localizeString()
        lblSCountryNameTitle.text = "Country".localizeString()
    }
    
    func moveToCompanyDetailVC(companyName: String, dataType: Int) {
        let companyDetailVC = UIStoryboard(name: "GraphViews", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailVC") as! CompanyDetailVC
        companyDetailVC.modalPresentationStyle = .overFullScreen
        companyDetailVC.companyName = companyName
        companyDetailVC.dataType = dataType
        present(companyDetailVC, animated: false)
    }
    
    func configureAPIData(obj: CompanyDetailModel?) {
        guard let obj = obj else { return }
        lblTransactionDate.text = obj.date?.convertSecondsToDateString()
        lblBillLandNum.text = getText(text: obj.billOfLadingNumber ?? "")
        lblHSCode.text = getText(text: obj.hsCode ?? "")
        lblWeight.text = getText(text: "\(obj.grossWeight ?? 0)" + (obj.weightUnit ?? ""))
        lblQuantity.text = "\(obj.quantity ?? 0)" + (obj.quantityUnit ?? "")
        lblTransportMode.text = getText(text: obj.transportationMethod ?? "")
        lblTradingProducts.text = getText(text: obj.detailedProductName ?? "")
        
        lblSupplierCompanyName.text = obj.exporter ?? ""
        lblSupplierCountry.text = (obj.exporterCountry ?? "").getCountryName()
        
        lblBuyerCompanyName.text = obj.importer ?? ""
        lblBuyerCountry.text = (obj.importerCountry ?? "").getCountryName()
        
        if obj.amountUSD > 0.0 {
            lblAmount.text = "\(obj.amountUSD ?? 0.0)"
        } else {
            lblAmount.text = "Undisclosed"
        }
        
        if selectedImportExportType == .Import {
            lblPortEntry.text = obj.localPort ?? ""
            lblExportPort.text = obj.foreignPort ?? ""
        } else {
            lblPortEntry.text = obj.foreignPort ?? ""
            lblExportPort.text = obj.localPort ?? ""
        }
    }
    
    func getText(text: String) -> String {
        guard !text.isEmpty else { return "Undisclosed" }
        return text
    }
    
    // MARK: - Custom Actions
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func buyerCompanyTapped(_ sender: UIButton) {
        moveToCompanyDetailVC(companyName: companyDetailData?.importer ?? "", dataType: 0)
    }
    
    @IBAction func supplierCompanyTapped(_ sender: UIButton) {
        moveToCompanyDetailVC(companyName: companyDetailData?.exporter ?? "", dataType: 1)
    }
}

extension TradeRecordDetailVC: CompanyDetailViewModelDelegate {
    func didReceiveDetailResponse(response: CompanyDetailModel?, error: String?) {
        hideLoader()
        if error == nil && response == nil {
            moveToPaymentVC()
        } else {
            if error == nil {
                companyDetailData = response
                configureAPIData(obj: response)
            } else {
                showAlert(message: error ?? "")
            }
        }
    }
}


extension String {
    func getCountryName() -> String {
        // Find the country from the country list by its code
        if let country = CountryManager.shared.countries.first(where: { $0.countryCode.uppercased() == self.uppercased() }) {
            return country.countryName
        }
        return ""
    }
    
    func getCountryImage() -> UIImage {
        // Find the country from the country list by its code
        if let country = CountryManager.shared.countries.first(where: { $0.countryCode.uppercased() == self.uppercased() }) {
            return country.flag ?? UIImage()
        }
        return UIImage()
    }
}
